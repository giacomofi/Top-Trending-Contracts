['# @version 0.2.12\n', '\n', '"""\n', '@title Unagii Token\n', '@author stakewith.us\n', '@license AGPL-3.0-or-later\n', '"""\n', '\n', 'VERSION: constant(String[28]) = "0.1.0"\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', 'implements: ERC20\n', '\n', '\n', 'interface DetailedERC20:\n', '    def name() -> String[42]: view\n', '    def symbol() -> String[20]: view\n', '    # Vyper does not support uint8\n', '    def decimals() -> uint256: view\n', '\n', '\n', 'event Transfer:\n', '    sender: indexed(address)\n', '    receiver: indexed(address)\n', '    value: uint256\n', '\n', '\n', 'event Approval:\n', '    owner: indexed(address)\n', '    spender: indexed(address)\n', '    value: uint256\n', '\n', '\n', 'event SetNextTimeLock:\n', '    timeLock: address\n', '\n', '\n', 'event AcceptTimeLock:\n', '    timeLock: address\n', '\n', '\n', 'event SetMinter:\n', '    minter: address\n', '\n', '\n', 'name: public(String[64])\n', 'symbol: public(String[32])\n', '# Vyper does not support uint8\n', 'decimals: public(uint256)\n', 'balanceOf: public(HashMap[address, uint256])\n', 'allowance: public(HashMap[address, HashMap[address, uint256]])\n', 'totalSupply: public(uint256)\n', '\n', '# EIP 2612 #\n', '# https://eips.ethereum.org/EIPS/eip-2612\n', '# `nonces` track `permit` approvals with signature.\n', 'nonces: public(HashMap[address, uint256])\n', 'DOMAIN_SEPARATOR: public(bytes32)\n', 'DOMAIN_TYPE_HASH: constant(bytes32) = keccak256(\n', '    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"\n', ')\n', 'PERMIT_TYPE_HASH: constant(bytes32) = keccak256(\n', '    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"\n', ')\n', '\n', 'timeLock: public(address)\n', 'nextTimeLock: public(address)\n', 'minter: public(address)\n', 'token: public(ERC20)\n', '# placeholder address used when token ETH\n', 'ETH: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE\n', '# last block number balance of msg.sender was changed (mint, burn, transfer, transferFrom)\n', 'lastBlock: public(HashMap[address, uint256])\n', '\n', '\n', '@external\n', 'def __init__(token: address):\n', '    self.timeLock = msg.sender\n', '    self.token = ERC20(token)\n', '\n', '    if token == ETH:\n', '        self.name = "unagii_ETH_v2"\n', '        self.symbol = "uETHv2"\n', '        self.decimals = 18\n', '    else:\n', '        self.name = concat("unagii_", DetailedERC20(token).name(), "_v2")\n', '        self.symbol = concat("u", DetailedERC20(token).symbol(), "v2")\n', '        self.decimals = DetailedERC20(token).decimals()\n', '\n', '    self.DOMAIN_SEPARATOR = keccak256(\n', '        concat(\n', '            DOMAIN_TYPE_HASH,\n', '            keccak256(convert("unagii", Bytes[6])),\n', '            keccak256(convert(VERSION, Bytes[28])),\n', '            convert(chain.id, bytes32),\n', '            convert(self, bytes32),\n', '        )\n', '    )\n', '\n', '\n', '@external\n', 'def setName(name: String[42]):\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    self.name = name\n', '\n', '\n', '@external\n', 'def setSymbol(symbol: String[20]):\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    self.symbol = symbol\n', '\n', '\n', '@external\n', 'def setNextTimeLock(nextTimeLock: address):\n', '    """\n', '    @notice Set next time lock\n', '    @param nextTimeLock Address of next time lock\n', '    """\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    # allow next time lock = zero address (cancel next time lock)\n', '    self.nextTimeLock = nextTimeLock\n', '    log SetNextTimeLock(nextTimeLock)\n', '\n', '\n', '@external\n', 'def acceptTimeLock():\n', '    """\n', '    @notice Accept time lock\n', '    @dev Only `nextTimeLock` can claim time lock\n', '    """\n', '    assert msg.sender == self.nextTimeLock, "!next time lock"\n', '    self.timeLock = msg.sender\n', '    log AcceptTimeLock(msg.sender)\n', '\n', '\n', '@external\n', 'def setMinter(minter: address):\n', '    """\n', '    @notice Set minter\n', '    @param minter Address of minter\n', '    """\n', '    assert msg.sender == self.timeLock, "!time lock"\n', '    # allow minter = zero address\n', '    self.minter = minter\n', '    log SetMinter(minter)\n', '\n', '\n', '@internal\n', 'def _transfer(_from: address, _to: address, amount: uint256):\n', '    assert _to not in [self, ZERO_ADDRESS], "invalid receiver"\n', '\n', '    # track lastest tx\n', '    self.lastBlock[_from] = block.number\n', '    self.lastBlock[_to] = block.number\n', '\n', '    self.balanceOf[_from] -= amount\n', '    self.balanceOf[_to] += amount\n', '    log Transfer(_from, _to, amount)\n', '\n', '\n', '@external\n', 'def transfer(_to: address, amount: uint256) -> bool:\n', '    self._transfer(msg.sender, _to, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def transferFrom(_from: address, _to: address, amount: uint256) -> bool:\n', '    # skip if unlimited approval\n', '    if self.allowance[_from][msg.sender] < MAX_UINT256:\n', '        self.allowance[_from][msg.sender] -= amount\n', '        log Approval(_from, msg.sender, self.allowance[_from][msg.sender])\n', '    self._transfer(_from, _to, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def approve(spender: address, amount: uint256) -> bool:\n', '    self.allowance[msg.sender][spender] = amount\n', '    log Approval(msg.sender, spender, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def increaseAllowance(spender: address, amount: uint256) -> bool:\n', '    self.allowance[msg.sender][spender] += amount\n', '    log Approval(msg.sender, spender, self.allowance[msg.sender][spender])\n', '    return True\n', '\n', '\n', '@external\n', 'def decreaseAllowance(spender: address, amount: uint256) -> bool:\n', '    self.allowance[msg.sender][spender] -= amount\n', '    log Approval(msg.sender, spender, self.allowance[msg.sender][spender])\n', '    return True\n', '\n', '\n', '@external\n', 'def permit(\n', '    owner: address,\n', '    spender: address,\n', '    amount: uint256,\n', '    deadline: uint256,\n', '    v: uint256,\n', '    r: bytes32,\n', '    s: bytes32,\n', '):\n', '    """\n', "    @notice Approves spender by owner's signature to expend owner's tokens.\n", '            https://eips.ethereum.org/EIPS/eip-2612\n', '    @dev Vyper does not have `uint8`, so replace `v: uint8` with `v: uint256`\n', '    """\n', '    assert owner != ZERO_ADDRESS, "owner = 0 address"\n', '    assert deadline >= block.timestamp, "expired"\n', '\n', '    digest: bytes32 = keccak256(\n', '        concat(\n', '            b"\\x19\\x01",\n', '            self.DOMAIN_SEPARATOR,\n', '            keccak256(\n', '                concat(\n', '                    PERMIT_TYPE_HASH,\n', '                    convert(owner, bytes32),\n', '                    convert(spender, bytes32),\n', '                    convert(amount, bytes32),\n', '                    convert(self.nonces[owner], bytes32),\n', '                    convert(deadline, bytes32),\n', '                )\n', '            ),\n', '        )\n', '    )\n', '\n', '    _r: uint256 = convert(r, uint256)\n', '    _s: uint256 = convert(s, uint256)\n', '    assert ecrecover(digest, v, _r, _s) == owner, "invalid signature"\n', '\n', '    self.nonces[owner] += 1\n', '    self.allowance[owner][spender] = amount\n', '    log Approval(owner, spender, amount)\n', '\n', '\n', '@external\n', 'def mint(_to: address, amount: uint256):\n', '    assert msg.sender == self.minter, "!minter"\n', '    assert _to not in [self, ZERO_ADDRESS], "invalid receiver"\n', '\n', '    # track lastest tx\n', '    self.lastBlock[_to] = block.number\n', '\n', '    self.totalSupply += amount\n', '    self.balanceOf[_to] += amount\n', '    log Transfer(ZERO_ADDRESS, _to, amount)\n', '\n', '\n', '@external\n', 'def burn(_from: address, amount: uint256):\n', '    assert msg.sender == self.minter, "!minter"\n', '    assert _from != ZERO_ADDRESS, "from = 0"\n', '\n', '    # track lastest tx\n', '    self.lastBlock[_from] = block.number\n', '\n', '    self.totalSupply -= amount\n', '    self.balanceOf[_from] -= amount\n', '    log Transfer(_from, ZERO_ADDRESS, amount)']