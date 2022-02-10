['# @version 0.2.8\n', '"""\n', '@title Uniswap Burner\n', '@notice Swaps coins to USDC using Uniswap or Sushi, and transfers to `UnderlyingBurner`\n', '"""\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', '\n', 'WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2\n', 'USDC: constant(address) = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48\n', '\n', 'ROUTERS: constant(address[2]) = [\n', '    0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,  # uniswap\n', '    0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F   # sushi\n', ']\n', '\n', '\n', 'is_approved: HashMap[address, HashMap[address, bool]]\n', '\n', 'receiver: public(address)\n', 'recovery: public(address)\n', 'is_killed: public(bool)\n', '\n', 'owner: public(address)\n', 'emergency_owner: public(address)\n', 'future_owner: public(address)\n', 'future_emergency_owner: public(address)\n', '\n', '\n', '@external\n', 'def __init__(_receiver: address, _recovery: address, _owner: address, _emergency_owner: address):\n', '    """\n', '    @notice Contract constructor\n', '    @param _receiver Address that converted tokens are transferred to.\n', '                     Should be set to an `UnderlyingBurner` deployment.\n', '    @param _recovery Address that tokens are transferred to during an\n', '                     emergency token recovery.\n', '    @param _owner Owner address. Can kill the contract, recover tokens\n', '                  and modify the recovery address.\n', '    @param _emergency_owner Emergency owner address. Can kill the contract\n', '                            and recover tokens.\n', '    """\n', '    self.receiver = _receiver\n', '    self.recovery = _recovery\n', '    self.owner = _owner\n', '    self.emergency_owner = _emergency_owner\n', '\n', '\n', '@external\n', 'def burn(_coin: address) -> bool:\n', '    """\n', '    @notice Receive `_coin` and swap it for USDC using Uniswap or Sushi\n', '    @param _coin Address of the coin being converted\n', '    @return bool success\n', '    """\n', '    assert not self.is_killed  # dev: is killed\n', '\n', '    # transfer coins from caller\n', '    amount: uint256 = ERC20(_coin).balanceOf(msg.sender)\n', '    if amount != 0:\n', '        response: Bytes[32] = raw_call(\n', '            _coin,\n', '            concat(\n', '                method_id("transferFrom(address,address,uint256)"),\n', '                convert(msg.sender, bytes32),\n', '                convert(self, bytes32),\n', '                convert(amount, bytes32),\n', '            ),\n', '            max_outsize=32,\n', '        )\n', '        if len(response) != 0:\n', '            assert convert(response, bool)\n', '\n', '    # get actual balance in case of transfer fee or pre-existing balance\n', '    amount = ERC20(_coin).balanceOf(self)\n', '\n', '    best_expected: uint256 = 0\n', '    router: address = ZERO_ADDRESS\n', '\n', '    # check the rates on uniswap and sushi to see which is the better option\n', "    # vyper doesn't support dynamic arrays, so we build the calldata manually\n", '    for addr in ROUTERS:\n', '        response: Bytes[128] = raw_call(\n', '            addr,\n', '            concat(\n', '                method_id("getAmountsOut(uint256,address[])"),\n', '                convert(amount, bytes32),\n', '                convert(64, bytes32),\n', '                convert(3, bytes32),\n', '                convert(_coin, bytes32),\n', '                convert(WETH, bytes32),\n', '                convert(USDC, bytes32),\n', '            ),\n', '            max_outsize=128\n', '        )\n', '        expected: uint256 = convert(slice(response, 96, 32), uint256)\n', '        if expected > best_expected:\n', '            best_expected = expected\n', '            router = addr\n', '\n', '    # make sure the router is approved to transfer the coin\n', '    if not self.is_approved[router][_coin]:\n', '        response: Bytes[32] = raw_call(\n', '            _coin,\n', '            concat(\n', '                method_id("approve(address,uint256)"),\n', '                convert(router, bytes32),\n', '                convert(MAX_UINT256, bytes32),\n', '            ),\n', '            max_outsize=32,\n', '        )\n', '        if len(response) != 0:\n', '            assert convert(response, bool)\n', '        self.is_approved[router][_coin] = True\n', '\n', '    # swap for USDC on whichever of uniswap/sushi gives a better rate\n', "    # vyper doesn't support dynamic arrays, so we build the calldata manually\n", '    raw_call(\n', '        router,\n', '        concat(\n', '            method_id("swapExactTokensForTokens(uint256,uint256,address[],address,uint256)"),\n', '            convert(amount, bytes32),           # swap amount\n', '            EMPTY_BYTES32,                      # min expected\n', '            convert(160, bytes32),              # offset pointer to path array\n', '            convert(self.receiver, bytes32),    # receiver of the swap\n', '            convert(block.timestamp, bytes32),  # swap deadline\n', '            convert(3, bytes32),                # path length\n', '            convert(_coin, bytes32),            # input token\n', '            convert(WETH, bytes32),             # weth (intermediate swap)\n', '            convert(USDC, bytes32),             # usdc (final output)\n', '        )\n', '    )\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def recover_balance(_coin: address) -> bool:\n', '    """\n', '    @notice Recover ERC20 tokens from this contract\n', '    @dev Tokens are sent to the recovery address\n', '    @param _coin Token address\n', '    @return bool success\n', '    """\n', '    assert msg.sender in [self.owner, self.emergency_owner]  # dev: only owner\n', '\n', '    amount: uint256 = ERC20(_coin).balanceOf(self)\n', '    response: Bytes[32] = raw_call(\n', '        _coin,\n', '        concat(\n', '            method_id("transfer(address,uint256)"),\n', '            convert(self.recovery, bytes32),\n', '            convert(amount, bytes32),\n', '        ),\n', '        max_outsize=32,\n', '    )\n', '    if len(response) != 0:\n', '        assert convert(response, bool)\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def set_recovery(_recovery: address) -> bool:\n', '    """\n', '    @notice Set the token recovery address\n', '    @param _recovery Token recovery address\n', '    @return bool success\n', '    """\n', '    assert msg.sender == self.owner  # dev: only owner\n', '    self.recovery = _recovery\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def set_killed(_is_killed: bool) -> bool:\n', '    """\n', '    @notice Set killed status for this contract\n', '    @dev When killed, the `burn` function cannot be called\n', '    @param _is_killed Killed status\n', '    @return bool success\n', '    """\n', '    assert msg.sender in [self.owner, self.emergency_owner]  # dev: only owner\n', '    self.is_killed = _is_killed\n', '\n', '    return True\n', '\n', '\n', '\n', '@external\n', 'def commit_transfer_ownership(_future_owner: address) -> bool:\n', '    """\n', '    @notice Commit a transfer of ownership\n', '    @dev Must be accepted by the new owner via `accept_transfer_ownership`\n', '    @param _future_owner New owner address\n', '    @return bool success\n', '    """\n', '    assert msg.sender == self.owner  # dev: only owner\n', '    self.future_owner = _future_owner\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def accept_transfer_ownership() -> bool:\n', '    """\n', '    @notice Accept a transfer of ownership\n', '    @return bool success\n', '    """\n', '    assert msg.sender == self.future_owner  # dev: only owner\n', '    self.owner = msg.sender\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def commit_transfer_emergency_ownership(_future_owner: address) -> bool:\n', '    """\n', '    @notice Commit a transfer of ownership\n', '    @dev Must be accepted by the new owner via `accept_transfer_ownership`\n', '    @param _future_owner New owner address\n', '    @return bool success\n', '    """\n', '    assert msg.sender == self.emergency_owner  # dev: only owner\n', '    self.future_emergency_owner = _future_owner\n', '\n', '    return True\n', '\n', '\n', '@external\n', 'def accept_transfer_emergency_ownership() -> bool:\n', '    """\n', '    @notice Accept a transfer of ownership\n', '    @return bool success\n', '    """\n', '    assert msg.sender == self.future_emergency_owner  # dev: only owner\n', '    self.emergency_owner = msg.sender\n', '\n', '    return True']