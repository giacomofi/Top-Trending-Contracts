['from vyper.interfaces import ERC20\n', '\n', 'implements: ERC20\n', '\n', 'event Transfer:\n', '    sender: indexed(address)\n', '    receiver: indexed(address)\n', '    value: uint256\n', '\n', '\n', 'event Approval:\n', '    owner: indexed(address)\n', '    spender: indexed(address)\n', '    value: uint256\n', '\n', '\n', 'allowance: public(HashMap[address, HashMap[address, uint256]])\n', 'balanceOf: public(HashMap[address, uint256])\n', 'totalSupply: public(uint256)\n', 'nonces: public(HashMap[address, uint256])\n', 'DOMAIN_SEPARATOR: public(bytes32)\n', "DOMAIN_TYPE_HASH: constant(bytes32) = keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)')\n", 'PERMIT_TYPE_HASH: constant(bytes32) = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")\n', '\n', 'renDOGE: constant(address) = 0x3832d2F059E55934220881F831bE501D180671A7\n', 'WDOGE: constant(address) = 0x35a532d376FFd9a705d0Bb319532837337A398E7\n', 'SHIB: constant(address) = 0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE\n', 'AKITA: constant(address) = 0x3301Ee63Fb29F863f2333Bd4466acb46CD8323E6\n', 'WOOFY: constant(address) = 0xD0660cD418a64a1d44E9214ad8e459324D8157f1\n', '\n', '@external\n', 'def __init__():\n', '    self.DOMAIN_SEPARATOR = keccak256(\n', '        concat(\n', '            DOMAIN_TYPE_HASH,\n', '            keccak256(convert("Doge5", Bytes[5])),\n', '            keccak256(convert("1", Bytes[1])),\n', '            convert(chain.id, bytes32),\n', '            convert(self, bytes32)\n', '        )\n', '    )\n', '\n', '\n', '@view\n', '@external\n', 'def name() -> String[5]:\n', '    return "Doge5"\n', '\n', '\n', '@view\n', '@external\n', 'def symbol() -> String[5]:\n', '    return "DOGE5"\n', '\n', '\n', '@view\n', '@external\n', 'def decimals() -> uint256:\n', '    return 18\n', '\n', '\n', '@internal\n', 'def _mint(receiver: address, amount: uint256):\n', '    assert not receiver in [self, ZERO_ADDRESS]\n', '\n', '    self.balanceOf[receiver] += amount\n', '    self.totalSupply += amount\n', '\n', '    log Transfer(ZERO_ADDRESS, receiver, amount)\n', '\n', '\n', '@internal\n', 'def _burn(sender: address, amount: uint256):\n', '    self.balanceOf[sender] -= amount\n', '    self.totalSupply -= amount\n', '\n', '    log Transfer(sender, ZERO_ADDRESS, amount)\n', '\n', '\n', '@internal\n', 'def _transfer(sender: address, receiver: address, amount: uint256):\n', '    assert not receiver in [self, ZERO_ADDRESS]\n', '\n', '    self.balanceOf[sender] -= amount\n', '    self.balanceOf[receiver] += amount\n', '\n', '    log Transfer(sender, receiver, amount)\n', '\n', '\n', '@external\n', 'def transfer(receiver: address, amount: uint256) -> bool:\n', '    self._transfer(msg.sender, receiver, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def transferFrom(sender: address, receiver: address, amount: uint256) -> bool:\n', '    self.allowance[sender][msg.sender] -= amount\n', '    self._transfer(sender, receiver, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def approve(spender: address, amount: uint256) -> bool:\n', '    self.allowance[msg.sender][spender] = amount\n', '    log Approval(msg.sender, spender, amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def woof(amount: uint256 = MAX_UINT256, receiver: address = msg.sender) -> bool:\n', '    mint_amount: uint256 = min(amount, ERC20(SHIB).balanceOf(msg.sender))\n', '    assert ERC20(SHIB).transferFrom(msg.sender, self, mint_amount)\n', '    assert ERC20(AKITA).transferFrom(msg.sender, self, mint_amount)\n', '    assert ERC20(WDOGE).transferFrom(msg.sender, self, mint_amount)\n', '    assert ERC20(renDOGE).transferFrom(msg.sender, self, mint_amount/(10**10))\n', '    assert ERC20(WOOFY).transferFrom(msg.sender, self, mint_amount/(10**6))\n', '    self._mint(receiver, mint_amount)\n', '    return True\n', '\n', '\n', '@external\n', 'def unwoof(amount: uint256 = MAX_UINT256, receiver: address = msg.sender) -> bool:\n', '    burn_amount: uint256 = min(amount, self.balanceOf[msg.sender])\n', '    self._burn(msg.sender, burn_amount)\n', '    assert ERC20(SHIB).transfer(receiver, burn_amount)\n', '    assert ERC20(AKITA).transfer(receiver, burn_amount)\n', '    assert ERC20(WDOGE).transfer(receiver, burn_amount)\n', '    assert ERC20(renDOGE).transfer(receiver, burn_amount/(10**10))\t\n', '    assert ERC20(WOOFY).transfer(receiver, burn_amount/(10**6))\t\t\n', '    return True\n', '\n', '\n', '@external\n', 'def permit(owner: address, spender: address, amount: uint256, expiry: uint256, signature: Bytes[65]) -> bool:\n', '    assert owner != ZERO_ADDRESS  # dev: invalid owner\n', '    assert expiry == 0 or expiry >= block.timestamp  # dev: permit expired\n', '    nonce: uint256 = self.nonces[owner]\n', '    digest: bytes32 = keccak256(\n', '        concat(\n', "            b'\\x19\\x01',\n", '            self.DOMAIN_SEPARATOR,\n', '            keccak256(\n', '                concat(\n', '                    PERMIT_TYPE_HASH,\n', '                    convert(owner, bytes32),\n', '                    convert(spender, bytes32),\n', '                    convert(amount, bytes32),\n', '                    convert(nonce, bytes32),\n', '                    convert(expiry, bytes32),\n', '                )\n', '            )\n', '        )\n', '    )\n', '    # NOTE: signature is packed as r, s, v\n', '    r: uint256 = convert(slice(signature, 0, 32), uint256)\n', '    s: uint256 = convert(slice(signature, 32, 32), uint256)\n', '    v: uint256 = convert(slice(signature, 64, 1), uint256)\n', '    assert ecrecover(digest, v, r, s) == owner  # dev: invalid signature\n', '    self.allowance[owner][spender] = amount\n', '    self.nonces[owner] = nonce + 1\n', '    log Approval(owner, spender, amount)\n', '    return True']