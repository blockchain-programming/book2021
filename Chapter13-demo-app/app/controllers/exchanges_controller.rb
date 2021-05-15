class ExchangesController < ApplicationController
  before_action :jpy_btc_rate, :satoshi, :set_user_account, :set_exchange_account, :set_chain_params

  require 'bitcoin'

  def new_bitcoin_to_jpy
    @exchange = Exchange.new
  end

  def create_bitcoin_to_jpy
    # 取引所の日本円残高履歴
    current_balance = @user.exchanges.exists? ? @user.exchanges.last.fiat_balance : 0
    # ビットコイン売却希望量 (satoshi)
    bitcoin = params[:exchange][:bitcoin_trading_volume].to_f * @satoshi

    if bitcoin > get_balance(@user_wallet) * @satoshi
      flash[:danger] = 'ビットコインの残高が不足しています'
    end

    # ビットコイン売却金額
    jpy = bitcoin / @satoshi * @jpy_btc_rate

    tx = exchange_bitcoin(@user_account.address, @user_account.private_key, @exchange_account.address, bitcoin, false)

    @exchange = @user.exchanges.build(
        user_id: @user.id,
        bitcoin_trading_volume: bitcoin.to_i,
        fiat_trading_volume: jpy.to_i,
        fiat_balance: (current_balance - jpy).to_i,
        blocktime: -1,
        tx_id: tx.txid
    )

    if @exchange.save
      @finance = @user.finance.update_attribute(:fiat_jpy, @user.finance.fiat_jpy + jpy)

      flash[:success] = '売却しました'
      redirect_to wallets_show_path
    else
      @exchange.save!
    end
  end

  def new_jpy_to_bitcoin
    @exchange = Exchange.new
  end

  def create_jpy_to_bitcoin
    current_balance = @user.exchanges.exists? ? @user.exchanges.last.fiat_balance : 0
    # ビットコイン購入希望金額
    jpy = params[:exchange][:fiat_trading_volume].to_f

    if jpy > @user.finance.fiat_jpy
      flash[:danger] = '買い付け余力が不足しています'
    end

    # ビットコイン購入量
    bitcoin = jpy / @jpy_btc_rate * @satoshi

    tx = exchange_bitcoin(@exchange_account.address, @exchange_account.private_key, @user_account.address, bitcoin)

    @exchange = @user.exchanges.build(
        user_id: @user.id,
        bitcoin_trading_volume: bitcoin.to_i,
        fiat_trading_volume: jpy.to_i,
        fiat_balance: (current_balance + jpy).to_i,
        blocktime: -1,
        tx_id: tx.txid
    )

    if @exchange.save
      @finance = @user.finance.update_attribute(:fiat_jpy, @user.finance.fiat_jpy - jpy)

      flash[:success] = '購入しました'
      redirect_to wallets_show_path
    else
      @exchange.save!
    end
  end

  private

  def jpy_btc_rate
    @jpy_btc_rate = 1000000
  end

  def satoshi
    @satoshi = 100000000
  end

  def set_user_account
    @user = User.find(current_user.id)
    @user_wallet = @user.wallet
    @user_account = @user_wallet.keys.find_by(wallet_id: @user_wallet.id)
  end

  def set_exchange_account
    @exchange_wallet = User.find_by(is_admin: true).wallet
    @exchange_account = @exchange_wallet.keys.find_by(wallet_id: @exchange_wallet.id)
  end

  def exchange_bitcoin(sender_address, sender_priv_key, receiver_address, trading_amount, is_send_with_fee=true)
    tx = Bitcoin::Tx.new
    # use CLTV
    tx.version = 2

    tx_fee = 10000

    # get utxo list
    utxos = get_utxo(sender_address)
    utxo = utxos.last

    utxo_amount = utxo['amount'] * @satoshi
    utxo_txid = utxo['txid']
    utxo_script_pubkey = utxo['scriptPubKey']

    logger.debug 'use this tx'
    logger.debug utxo_txid

    sending_amount = is_send_with_fee ? trading_amount - tx_fee : trading_amount
    # the amount of change
    change_amount = is_send_with_fee ? utxo_amount - trading_amount : utxo_amount - trading_amount - tx_fee

    tx.in << Bitcoin::TxIn.new(out_point: Bitcoin::OutPoint.from_txid(utxo_txid, 0))
    tx.out << Bitcoin::TxOut.new(value: sending_amount, script_pubkey: Bitcoin::Script.parse_from_addr(receiver_address))
    if change_amount != 0
      tx.out << Bitcoin::TxOut.new(value: change_amount, script_pubkey: Bitcoin::Script.parse_from_addr(sender_address))
    end

    input_index = 0
    script_pubkey = Bitcoin::Script.parse_from_payload(utxo_script_pubkey.htb)

    sig_hash = tx.sighash_for_input(input_index, script_pubkey, sig_version: :witness_v0, amount: utxo_amount)
    key = Bitcoin::Key.from_wif(sender_priv_key)
    signature = key.sign(sig_hash) + [Bitcoin::SIGHASH_TYPE[:all]].pack('C')

    tx.in[0].script_witness.stack << signature << key.pubkey.htb

    pp tx.verify_input_sig(0, script_pubkey, amount: utxo_amount)
    pp tx.to_payload.bth; nil

    bitcoin_client.sendrawtransaction(tx.to_payload.bth)

    tx
  end
end
