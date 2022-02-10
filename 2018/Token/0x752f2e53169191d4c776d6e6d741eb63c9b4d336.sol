['pragma solidity ^0.4.24;\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * See https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', "    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "    // benefit is lost if 'b' is also tested.\n", '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', "    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold\n", '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) internal balances;\n', '\n', '  uint256 internal totalSupply_;\n', '\n', '  /**\n', '  * @dev Total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev Transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_value <= balances[msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * https://github.com/ethereum/EIPs/issues/20\n', ' * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '    require(_to != address(0));\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(\n', '    address _owner,\n', '    address _spender\n', '   )\n', '    public\n', '    view\n', '    returns (uint256)\n', '  {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(\n', '    address _spender,\n', '    uint256 _addedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    allowed[msg.sender][_spender] = (\n', '      allowed[msg.sender][_spender].add(_addedValue));\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(\n', '    address _spender,\n', '    uint256 _subtractedValue\n', '  )\n', '    public\n', '    returns (bool)\n', '  {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue >= oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/FreeFeeCoin.sol\n', '\n', '/**\n', ' * @title FreeFeeCoin contract\n', ' */\n', 'contract FreeFeeCoin is StandardToken {\n', '    string public symbol;\n', '    string public name;\n', '    uint8 public decimals = 9;\n', '\n', '    uint noOfTokens = 2500000000; // 2,500,000,000 (2.5B)\n', '\n', '    // Address of freefeecoin vault (a FreeFeeCoinMultiSigWallet contract)\n', '    // The vault will have all the freefeecoin issued and the operation\n', '    // on its token will be protected by multi signing.\n', '    // In addtion, vault can recall(transfer back) the reserved amount\n', '    // from some address.\n', '    address internal vault;\n', '\n', '    // Address of freefeecoin owner (a FreeFeeCoinMultiSigWallet contract)\n', '    // The owner can change admin and vault address, but the change operation\n', '    // will be protected by multi signing.\n', '    address internal owner;\n', '\n', '    // Address of freefeecoin admin (a FreeFeeCoinMultiSigWallet contract)\n', '    // The admin can change reserve. The reserve is the amount of token\n', '    // assigned to some address but not permitted to use.\n', '    // Once the signers of the admin agree with removing the reserve,\n', '    // they can change the reserve to zero to permit the user to use all reserved\n', '    // amount. So in effect, reservation will postpone the use of some tokens\n', '    // being used until all stakeholders agree with giving permission to use that\n', '    // token to the token owner.\n', '    // All admin operation will be protected by multi signing.\n', '    address internal admin;\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '    event VaultChanged(address indexed previousVault, address indexed newVault);\n', '    event AdminChanged(address indexed previousAdmin, address indexed newAdmin);\n', '    event ReserveChanged(address indexed _address, uint amount);\n', '    event Recalled(address indexed from, uint amount);\n', '\n', '    // for debugging\n', '    event MsgAndValue(string message, bytes32 value);\n', '\n', '    /**\n', '     * @dev reserved number of tokens per each address\n', '     *\n', '     * To limit token transaction for some period by the admin or owner,\n', "     * each address' balance cannot become lower than this amount\n", '     *\n', '     */\n', '    mapping(address => uint) public reserves;\n', '\n', '    /**\n', '       * @dev modifier to limit access to the owner only\n', '       */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to the vault only\n', '       */\n', '    modifier onlyVault() {\n', '        require(msg.sender == vault);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to the admin only\n', '       */\n', '    modifier onlyAdmin() {\n', '        require(msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to admin or vault\n', '       */\n', '    modifier onlyAdminOrVault() {\n', '        require(msg.sender == vault || msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to owner or vault\n', '       */\n', '    modifier onlyOwnerOrVault() {\n', '        require(msg.sender == owner || msg.sender == vault);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to owner or admin\n', '       */\n', '    modifier onlyAdminOrOwner() {\n', '        require(msg.sender == owner || msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '       * @dev limit access to owner or admin or vault\n', '       */\n', '    modifier onlyAdminOrOwnerOrVault() {\n', '        require(msg.sender == owner || msg.sender == vault || msg.sender == admin);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev initialize ERC20\n', '     *\n', '     * all token will deposit into the vault\n', '     * later, the vault, owner will be multi sign contract to protect privileged operations\n', '     *\n', '     * @param _symbol token symbol\n', '     * @param _name   token name\n', '     * @param _owner  owner address\n', '     * @param _admin  admin address\n', '     * @param _vault  vault address\n', '     */\n', '    constructor (string _symbol, string _name, address _owner, address _admin, address _vault) public {\n', '        require(bytes(_symbol).length > 0);\n', '        require(bytes(_name).length > 0);\n', '\n', '        totalSupply_ = noOfTokens * (10 ** uint(decimals));\n', '        // 2.5E9 tokens initially\n', '\n', '        symbol = _symbol;\n', '        name = _name;\n', '        owner = _owner;\n', '        admin = _admin;\n', '        vault = _vault;\n', '\n', '        balances[vault] = totalSupply_;\n', '        emit Transfer(address(0), vault, totalSupply_);\n', '    }\n', '\n', '    /**\n', '     * @dev change the amount of reserved token\n', '     *    reserve should be less than or equal to the current token balance\n', '     *\n', '     *    Refer to the comment on the admin if you want to know more.\n', '     *\n', '     * @param _address the target address whose token will be frozen for future use\n', '     * @param _reserve  the amount of reserved token\n', '     *\n', '     */\n', '    function setReserve(address _address, uint _reserve) public onlyAdmin {\n', '        require(_reserve <= totalSupply_);\n', '        require(_address != address(0));\n', '\n', '        reserves[_address] = _reserve;\n', '        emit ReserveChanged(_address, _reserve);\n', '    }\n', '\n', '    /**\n', '     * @dev transfer token from sender to other\n', '     *         the result balance should be greater than or equal to the reserved token amount\n', '     */\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        // check the reserve\n', '        require(balanceOf(msg.sender) - _value >= reserveOf(msg.sender));\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev change vault address\n', '     *    BEWARE! this withdraw all token from old vault and store it to the new vault\n', "     *            and new vault's allowed, reserve will be set to zero\n", '     * @param _newVault new vault address\n', '     */\n', '    function setVault(address _newVault) public onlyOwner {\n', '        require(_newVault != address(0));\n', '        require(_newVault != vault);\n', '\n', '        address _oldVault = vault;\n', '\n', '        // change vault address\n', '        vault = _newVault;\n', '        emit VaultChanged(_oldVault, _newVault);\n', '\n', '        // adjust balance\n', '        uint _value = balances[_oldVault];\n', '        balances[_oldVault] = 0;\n', '        balances[_newVault] = balances[_newVault].add(_value);\n', '\n', '        // vault cannot have any allowed or reserved amount!!!\n', '        allowed[_newVault][msg.sender] = 0;\n', '        reserves[_newVault] = 0;\n', '        emit Transfer(_oldVault, _newVault, _value);\n', '    }\n', '\n', '    /**\n', '     * @dev change owner address\n', '     * @param _newOwner new owner address\n', '     */\n', '    function setOwner(address _newOwner) public onlyVault {\n', '        require(_newOwner != address(0));\n', '        require(_newOwner != owner);\n', '\n', '        owner = _newOwner;\n', '        emit OwnerChanged(owner, _newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev change admin address\n', '     * @param _newAdmin new admin address\n', '     */\n', '    function setAdmin(address _newAdmin) public onlyOwnerOrVault {\n', '        require(_newAdmin != address(0));\n', '        require(_newAdmin != admin);\n', '\n', '        admin = _newAdmin;\n', '\n', '        emit AdminChanged(admin, _newAdmin);\n', '    }\n', '\n', '    /**\n', '     * @dev transfer a part of reserved amount to the vault\n', '     *\n', '     *    Refer to the comment on the vault if you want to know more.\n', '     *\n', '     * @param _from the address from which the reserved token will be taken\n', '     * @param _amount the amount of token to be taken\n', '     */\n', '    function recall(address _from, uint _amount) public onlyAdmin {\n', '        require(_from != address(0));\n', '        require(_amount > 0);\n', '\n', '        uint currentReserve = reserveOf(_from);\n', '        uint currentBalance = balanceOf(_from);\n', '\n', '        require(currentReserve >= _amount);\n', '        require(currentBalance >= _amount);\n', '\n', '        uint newReserve = currentReserve - _amount;\n', '        reserves[_from] = newReserve;\n', '        emit ReserveChanged(_from, newReserve);\n', '\n', '        // transfer token _from to vault\n', '        balances[_from] = balances[_from].sub(_amount);\n', '        balances[vault] = balances[vault].add(_amount);\n', '        emit Transfer(_from, vault, _amount);\n', '\n', '        emit Recalled(_from, _amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     *\n', "     * The _from's FFC balance should be larger than the reserved amount(reserves[_from]) plus _value.\n", '     *\n', '     */\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_value <= balances[_from].sub(reserves[_from]));\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '    function getOwner() public view onlyAdminOrOwnerOrVault returns (address) {\n', '        return owner;\n', '    }\n', '\n', '    function getVault() public view onlyAdminOrOwnerOrVault returns (address) {\n', '        return vault;\n', '    }\n', '\n', '    function getAdmin() public view onlyAdminOrOwnerOrVault returns (address) {\n', '        return admin;\n', '    }\n', '\n', '    function getOneFreeFeeCoin() public view returns (uint) {\n', '        return (10 ** uint(decimals));\n', '    }\n', '\n', '    function getMaxNumberOfTokens() public view returns (uint) {\n', '        return noOfTokens;\n', '    }\n', '\n', '    /**\n', '     * @dev get the amount of reserved token\n', '     */\n', '    function reserveOf(address _address) public view returns (uint _reserve) {\n', '        return reserves[_address];\n', '    }\n', '\n', '    /**\n', '     * @dev get the amount reserved token of the sender\n', '     */\n', '    function reserve() public view returns (uint _reserve) {\n', '        return reserves[msg.sender];\n', '    }\n', '}']