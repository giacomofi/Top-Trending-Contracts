['# @version 0.2.4\n', '"""\n', '@title Curve LP Token\n', '@author Curve.Fi\n', '@notice Base implementation for an LP token provided for\n', '        supplying liquidity to `StableSwap`\n', '@dev Follows the ERC-20 token standard as defined at\n', '     https://eips.ethereum.org/EIPS/eip-20\n', '"""\n', '\n', 'from vyper.interfaces import ERC20\n', '\n', 'implements: ERC20\n', '\n', 'interface Curve:\n', '    def owner() -> address: view\n', '\n', '\n', 'event Transfer:\n', '    _from: indexed(address)\n', '    _to: indexed(address)\n', '    _value: uint256\n', '\n', 'event Approval:\n', '    _owner: indexed(address)\n', '    _spender: indexed(address)\n', '    _value: uint256\n', '\n', '\n', 'name: public(String[64])\n', 'symbol: public(String[32])\n', 'decimals: public(uint256)\n', '\n', "# NOTE: By declaring `balanceOf` as public, vyper automatically generates a 'balanceOf()' getter\n", '#       method to allow access to account balances.\n', '#       The _KeyType will become a required parameter for the getter and it will return _ValueType.\n', '#       See: https://vyper.readthedocs.io/en/v0.1.0-beta.8/types.html?highlight=getter#mappings\n', 'balanceOf: public(HashMap[address, uint256])\n', 'allowances: HashMap[address, HashMap[address, uint256]]\n', 'total_supply: uint256\n', 'minter: address\n', '\n', '\n', '@external\n', 'def __init__(_name: String[64], _symbol: String[32], _decimals: uint256, _supply: uint256):\n', '    init_supply: uint256 = _supply * 10 ** _decimals\n', '    self.name = _name\n', '    self.symbol = _symbol\n', '    self.decimals = _decimals\n', '    self.balanceOf[msg.sender] = init_supply\n', '    self.total_supply = init_supply\n', '    self.minter = msg.sender\n', '    log Transfer(ZERO_ADDRESS, msg.sender, init_supply)\n', '\n', '\n', '@external\n', 'def set_minter(_minter: address):\n', '    assert msg.sender == self.minter\n', '    self.minter = _minter\n', '\n', '\n', '@external\n', 'def set_name(_name: String[64], _symbol: String[32]):\n', '    assert Curve(self.minter).owner() == msg.sender\n', '    self.name = _name\n', '    self.symbol = _symbol\n', '\n', '\n', '@view\n', '@external\n', 'def totalSupply() -> uint256:\n', '    """\n', '    @dev Total number of tokens in existence.\n', '    """\n', '    return self.total_supply\n', '\n', '\n', '@view\n', '@external\n', 'def allowance(_owner : address, _spender : address) -> uint256:\n', '    """\n', '    @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '    @param _owner The address which owns the funds.\n', '    @param _spender The address which will spend the funds.\n', '    @return An uint256 specifying the amount of tokens still available for the spender.\n', '    """\n', '    return self.allowances[_owner][_spender]\n', '\n', '\n', '@external\n', 'def transfer(_to : address, _value : uint256) -> bool:\n', '    """\n', '    @dev Transfer token for a specified address\n', '    @param _to The address to transfer to.\n', '    @param _value The amount to be transferred.\n', '    """\n', '    # NOTE: vyper does not allow underflows\n', '    #       so the following subtraction would revert on insufficient balance\n', '    self.balanceOf[msg.sender] -= _value\n', '    self.balanceOf[_to] += _value\n', '    log Transfer(msg.sender, _to, _value)\n', '    return True\n', '\n', '\n', '@external\n', 'def transferFrom(_from : address, _to : address, _value : uint256) -> bool:\n', '    """\n', '     @dev Transfer tokens from one address to another.\n', '     @param _from address The address which you want to send tokens from\n', '     @param _to address The address which you want to transfer to\n', '     @param _value uint256 the amount of tokens to be transferred\n', '    """\n', '    # NOTE: vyper does not allow underflows\n', '    #       so the following subtraction would revert on insufficient balance\n', '    self.balanceOf[_from] -= _value\n', '    self.balanceOf[_to] += _value\n', '    if msg.sender != self.minter:  # minter is allowed to transfer anything\n', '        _allowance: uint256 = self.allowances[_from][msg.sender]\n', '        if _allowance != MAX_UINT256:\n', '            # NOTE: vyper does not allow underflows\n', '            # so the following subtraction would revert on insufficient allowance\n', '            self.allowances[_from][msg.sender] = _allowance - _value\n', '    log Transfer(_from, _to, _value)\n', '    return True\n', '\n', '\n', '@external\n', 'def approve(_spender : address, _value : uint256) -> bool:\n', '    """\n', '    @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '         Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '         and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "         race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '         https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '    @param _spender The address which will spend the funds.\n', '    @param _value The amount of tokens to be spent.\n', '    """\n', '    assert _value == 0 or self.allowances[msg.sender][_spender] == 0\n', '    self.allowances[msg.sender][_spender] = _value\n', '    log Approval(msg.sender, _spender, _value)\n', '    return True\n', '\n', '\n', '@external\n', 'def mint(_to: address, _value: uint256) -> bool:\n', '    """\n', '    @dev Mint an amount of the token and assigns it to an account.\n', '         This encapsulates the modification of balances such that the\n', '         proper events are emitted.\n', '    @param _to The account that will receive the created tokens.\n', '    @param _value The amount that will be created.\n', '    """\n', '    assert msg.sender == self.minter\n', '    assert _to != ZERO_ADDRESS\n', '    self.total_supply += _value\n', '    self.balanceOf[_to] += _value\n', '    log Transfer(ZERO_ADDRESS, _to, _value)\n', '    return True\n', '\n', '\n', '@external\n', 'def burnFrom(_to: address, _value: uint256) -> bool:\n', '    """\n', '    @dev Burn an amount of the token from a given account.\n', '    @param _to The account whose tokens will be burned.\n', '    @param _value The amount that will be burned.\n', '    """\n', '    assert msg.sender == self.minter\n', '    assert _to != ZERO_ADDRESS\n', '\n', '    self.total_supply -= _value\n', '    self.balanceOf[_to] -= _value\n', '    log Transfer(_to, ZERO_ADDRESS, _value)\n', '\n', '    return True']