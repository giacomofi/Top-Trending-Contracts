['# @version 0.2.12\n', '"""\n', '@title Curve CryptoSwap Deposit Zap\n', '@author Curve.Fi\n', '@license Copyright (c) Curve.Fi, 2020 - all rights reserved\n', '@dev Wraps / unwraps Ether, and redirects deposits / withdrawals\n', '"""\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', 'interface CurveCryptoSwap:\n', '    def add_liquidity(amounts: uint256[N_COINS], min_mint_amount: uint256): nonpayable\n', '    def remove_liquidity(_amount: uint256, min_amounts: uint256[N_COINS]): nonpayable\n', '    def remove_liquidity_one_coin(token_amount: uint256, i: uint256, min_amount: uint256): nonpayable\n', '    def token() -> address: view\n', '    def coins(i: uint256) -> address: view\n', '\n', 'interface wETH:\n', '    def deposit(): payable\n', '    def withdraw(_amount: uint256): nonpayable\n', '\n', '\n', 'N_COINS: constant(uint256) = 3\n', 'WETH_IDX: constant(uint256) = N_COINS - 1\n', 'WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2\n', '\n', 'pool: public(address)\n', 'token: public(address)\n', 'coins: public(address[N_COINS])\n', '\n', '\n', '@payable\n', '@external\n', 'def __default__():\n', '    assert msg.sender == WETH\n', '\n', '\n', '@external\n', 'def __init__(_pool: address):\n', '    """\n', '    @notice Contract constructor\n', '    @param _pool `CurveCryptoSwap` deployment to target\n', '    """\n', '    self.pool = _pool\n', '    self.token = CurveCryptoSwap(_pool).token()\n', '\n', '    for i in range(N_COINS):\n', '        coin: address = CurveCryptoSwap(_pool).coins(i)\n', '        response: Bytes[32] = raw_call(\n', '            coin,\n', '            concat(\n', '                method_id("approve(address,uint256)"),\n', '                convert(_pool, bytes32),\n', '                convert(MAX_UINT256, bytes32)\n', '            ),\n', '            max_outsize=32\n', '        )\n', '        if len(response) > 0:\n', '            assert convert(response, bool)  # dev: bad response\n', '        self.coins[i] = coin\n', '\n', '    assert self.coins[WETH_IDX] == WETH\n', '\n', '\n', '@payable\n', '@external\n', 'def add_liquidity(\n', '    _amounts: uint256[N_COINS],\n', '    _min_mint_amount: uint256,\n', '    _receiver: address = msg.sender\n', ') -> uint256:\n', '    """\n', '    @notice Add liquidity and wrap Ether to wETH\n', '    @param _amounts Amount of each token to deposit. `msg.value` must be\n', '                    equal to the given amount of Ether.\n', '    @param _min_mint_amount Minimum amount of LP token to receive\n', '    @param _receiver Receiver of the LP tokens\n', '    @return Amount of LP tokens received\n', '    """\n', '    assert msg.value == _amounts[WETH_IDX]\n', '    wETH(WETH).deposit(value=msg.value)\n', '\n', '    for i in range(N_COINS-1):\n', '        if _amounts[i] > 0:\n', '            response: Bytes[32] = raw_call(\n', '                self.coins[i],\n', '                concat(\n', '                    method_id("transferFrom(address,address,uint256)"),\n', '                    convert(msg.sender, bytes32),\n', '                    convert(self, bytes32),\n', '                    convert(_amounts[i], bytes32)\n', '                ),\n', '                max_outsize=32\n', '            )\n', '            if len(response) > 0:\n', '                assert convert(response, bool)  # dev: bad response\n', '\n', '    CurveCryptoSwap(self.pool).add_liquidity(_amounts, _min_mint_amount)\n', '    token: address = self.token\n', '    amount: uint256 = ERC20(token).balanceOf(self)\n', '    response: Bytes[32] = raw_call(\n', '        token,\n', '        concat(\n', '            method_id("transfer(address,uint256)"),\n', '            convert(_receiver, bytes32),\n', '            convert(amount, bytes32)\n', '        ),\n', '        max_outsize=32\n', '    )\n', '    if len(response) > 0:\n', '        assert convert(response, bool)  # dev: bad response\n', '\n', '    return amount\n', '\n', '\n', '@external\n', 'def remove_liquidity(\n', '    _amount: uint256,\n', '    _min_amounts: uint256[N_COINS],\n', '    _receiver: address = msg.sender\n', ') -> uint256[N_COINS]:\n', '    """\n', '    @notice Withdraw coins from the pool, unwrapping wETH to Ether\n', '    @dev Withdrawal amounts are based on current deposit ratios\n', '    @param _amount Quantity of LP tokens to burn in the withdrawal\n', '    @param _min_amounts Minimum amounts of coins to receive\n', '    @param _receiver Receiver of the withdrawn tokens\n', '    @return Amounts of coins that were withdrawn\n', '    """\n', '    ERC20(self.token).transferFrom(msg.sender, self, _amount)\n', '    CurveCryptoSwap(self.pool).remove_liquidity(_amount, _min_amounts)\n', '\n', '    amounts: uint256[N_COINS] = empty(uint256[N_COINS])\n', '    for i in range(N_COINS-1):\n', '        coin: address = self.coins[i]\n', '        amounts[i] = ERC20(coin).balanceOf(self)\n', '        response: Bytes[32] = raw_call(\n', '            coin,\n', '            concat(\n', '                method_id("transfer(address,uint256)"),\n', '                convert(_receiver, bytes32),\n', '                convert(amounts[i], bytes32)\n', '            ),\n', '            max_outsize=32\n', '        )\n', '        if len(response) > 0:\n', '            assert convert(response, bool)  # dev: bad response\n', '\n', '    amounts[WETH_IDX] = ERC20(WETH).balanceOf(self)\n', '    wETH(WETH).withdraw(amounts[WETH_IDX])\n', '    raw_call(_receiver, b"", value=self.balance)\n', '\n', '    return amounts\n', '\n', '\n', '@external\n', 'def remove_liquidity_one_coin(\n', '    _token_amount: uint256,\n', '    i: uint256,\n', '    _min_amount: uint256,\n', '    _receiver: address = msg.sender\n', ') -> uint256:\n', '    """\n', '    @notice Withdraw a single coin from the pool, unwrapping wETH to Ether\n', '    @param _token_amount Amount of LP tokens to burn in the withdrawal\n', '    @param i Index value of the coin to withdraw\n', '    @param _min_amount Minimum amount of coin to receive\n', '    @param _receiver Receiver of the withdrawn token\n', '    @return Amount of underlying coin received\n', '    """\n', '    ERC20(self.token).transferFrom(msg.sender, self, _token_amount)\n', '    CurveCryptoSwap(self.pool).remove_liquidity_one_coin(_token_amount, i, _min_amount)\n', '\n', '    coin: address = self.coins[i]\n', '    amount: uint256 = ERC20(coin).balanceOf(self)\n', '    if i == WETH_IDX:\n', '        wETH(WETH).withdraw(amount)\n', '        raw_call(_receiver, b"", value=self.balance)\n', '    else:\n', '        response: Bytes[32] = raw_call(\n', '            coin,\n', '            concat(\n', '                method_id("transfer(address,uint256)"),\n', '                convert(_receiver, bytes32),\n', '                convert(amount, bytes32)\n', '            ),\n', '            max_outsize=32\n', '        )\n', '        if len(response) > 0:\n', '            assert convert(response, bool)  # dev: bad response\n', '    return amount']