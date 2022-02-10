['# Copyright (C) 2021 VolumeFi Software, Inc.\n', '\n', '#  This program is free software: you can redistribute it and/or modify\n', '#  it under the terms of the Apache 2.0 License. \n', '#  This program is distributed WITHOUT ANY WARRANTY without even the implied warranty of\n', '#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n', '#  @author VolumeFi, Software inc.\n', '#  @notice This Vyper contract adds liquidity to any Uniswap V2 pool using ETH or any ERC20 Token.\n', '#  SPDX-License-Identifier: Apache-2.0\n', '\n', '# @version ^0.2.0\n', '\n', 'interface ERC20:\n', '    def approve(spender: address, amount: uint256): nonpayable\n', '    def transfer(recipient: address, amount: uint256): nonpayable\n', '    def transferFrom(sender: address, recipient: address, amount: uint256): nonpayable\n', '\n', 'interface UniswapV2Pair:\n', '    def token0() -> address: view\n', '    def token1() -> address: view\n', '\n', 'interface UniswapV2Router02:\n', '    def removeLiquidity(tokenA: address, tokenB: address, liquidity: uint256, amountAMin: uint256, amountBMin: uint256, to: address, deadline: uint256) -> (uint256, uint256): nonpayable\n', '\n', 'interface WrappedEth:\n', '    def withdraw(wad: uint256): nonpayable\n', '\n', 'UNISWAPV2ROUTER02: constant(address) = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D\n', '\n', 'VETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE\n', 'WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2\n', 'DEADLINE: constant(uint256) = MAX_UINT256 # change\n', '\n', 'paused: public(bool)\n', 'admin: public(address)\n', 'feeAmount: public(uint256)\n', 'feeAddress: public(address)\n', '\n', '@external\n', 'def __init__():\n', '    self.paused = False\n', '    self.admin = msg.sender\n', '    self.feeAddress = 0xf29399fB3311082d9F8e62b988cBA44a5a98ebeD\n', '    self.feeAmount = 1 * 10 ** 16\n', '\n', '@internal\n', 'def _token2Token(fromToken: address, toToken: address, tokens2Trade: uint256, to: address, deadline: uint256) -> uint256:\n', '    if fromToken == toToken:\n', '        return tokens2Trade\n', '    ERC20(fromToken).approve(UNISWAPV2ROUTER02, 0)\n', '    ERC20(fromToken).approve(UNISWAPV2ROUTER02, tokens2Trade)\n', '    \n', '    addrBytes: Bytes[288] = concat(convert(tokens2Trade, bytes32), convert(0, bytes32), convert(160, bytes32), convert(to, bytes32), convert(deadline, bytes32), convert(2, bytes32), convert(fromToken, bytes32), convert(toToken, bytes32))\n', '    funcsig: Bytes[4] = method_id("swapExactTokensForTokens(uint256,uint256,address[],address,uint256)")\n', '    full_data: Bytes[292] = concat(funcsig, addrBytes)\n', '    \n', '    _response: Bytes[128] = raw_call(\n', '        UNISWAPV2ROUTER02,\n', '        full_data,\n', '        max_outsize=128\n', '    )\n', '    tokenBought: uint256 = convert(slice(_response, 96, 32), uint256)\n', '    assert tokenBought > 0, "Error Swapping Token 2"\n', '    return tokenBought\n', '\n', '@external\n', '@payable\n', "@nonreentrant('lock')\n", 'def divestEthPairToToken(pair: address, token: address, amount: uint256, deadline: uint256=MAX_UINT256) -> uint256:\n', '    assert not self.paused, "Paused"\n', '    fee: uint256 = self.feeAmount\n', '    msg_value: uint256 = msg.value\n', '\n', '    assert msg.value >= fee, "Insufficient fee"\n', '    if msg.value > fee:\n', '        send(msg.sender, msg.value - fee)\n', '    send(self.feeAddress, fee)\n', '\n', '    assert pair != ZERO_ADDRESS, "Invalid Unipool Address"\n', '\n', '    token0: address = UniswapV2Pair(pair).token0()\n', '    token1: address = UniswapV2Pair(pair).token1()\n', '\n', '    assert token0 == WETH or token1 == WETH, "Not ETH Pair"\n', '\n', '    ERC20(pair).transferFrom(msg.sender, self, amount)\n', '    ERC20(pair).approve(UNISWAPV2ROUTER02, amount)\n', '\n', '    token0Amount: uint256 = 0\n', '    token1Amount: uint256 = 0\n', '    (token0Amount, token1Amount) = UniswapV2Router02(UNISWAPV2ROUTER02).removeLiquidity(token0, token1, amount, 1, 1, self, deadline)\n', '    tokenAmount: uint256 = 0\n', '    if token == token0:\n', '        tokenAmount = token0Amount + self._token2Token(token1, token0, token1Amount, self, deadline)\n', '        ERC20(token).transfer(msg.sender, tokenAmount)\n', '    elif token == token1:\n', '        tokenAmount = token1Amount + self._token2Token(token0, token1, token0Amount, self, deadline)\n', '        ERC20(token).transfer(msg.sender, tokenAmount)\n', '    elif token == VETH or token == ZERO_ADDRESS:\n', '        if token0 == WETH:\n', '            tokenAmount = token0Amount + self._token2Token(token1, token0, token1Amount, self, deadline)\n', '        else:\n', '            tokenAmount = token1Amount + self._token2Token(token0, token1, token0Amount, self, deadline)\n', '        WrappedEth(WETH).withdraw(tokenAmount)\n', '        send(msg.sender, tokenAmount)\n', '    elif token0 == WETH:\n', '        tokenAmount = token0Amount + self._token2Token(token1, token0, token1Amount, self, deadline)\n', '        tokenAmount = self._token2Token(WETH, token, tokenAmount, msg.sender, deadline)\n', '    elif token1 == WETH:\n', '        tokenAmount = token1Amount + self._token2Token(token0, token1, token0Amount, self, deadline)\n', '        tokenAmount = self._token2Token(WETH, token, tokenAmount, msg.sender, deadline)\n', '    else:\n', '        raise "Token ERROR"\n', '    return tokenAmount\n', '\n', '# Admin functions\n', '@external\n', 'def pause(_paused: bool):\n', '    assert msg.sender == self.admin, "Not admin"\n', '    self.paused = _paused\n', '\n', '@external\n', 'def newAdmin(_admin: address):\n', '    assert msg.sender == self.admin, "Not admin"\n', '    self.admin = _admin\n', '\n', '@external\n', 'def newFeeAmount(_feeAmount: uint256):\n', '    assert msg.sender == self.admin, "Not admin"\n', '    self.feeAmount = _feeAmount\n', '\n', '@external\n', 'def newFeeAddress(_feeAddress: address):\n', '    assert msg.sender == self.admin, "Not admin"\n', '    self.feeAddress = _feeAddress\n', '\n', '@external\n', '@payable\n', 'def __default__(): pass']