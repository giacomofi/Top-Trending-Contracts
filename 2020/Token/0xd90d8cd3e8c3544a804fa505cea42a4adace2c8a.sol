['/**\n', ' *Submitted for verification at Etherscan.io on 2019-06-03\n', '*/\n', '\n', '/**\n', ' * Source Code first verified at https://etherscan.io on Saturday, April 27, 2019\n', ' (UTC) */\n', '\n', 'pragma solidity ^0.4.25;\n', '// produced by the Solididy File Flattener (c) \n', '// released under Apache 2.0 licence\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', ' constructor() public  {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  uint256 totalSupply_ = 0;\n', '\n', '  /**\n', '  * @dev total number of tokens in existence\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalSupply_;\n', '  }\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit  Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit  Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From HSN Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {\n', '    uint256 oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '\n', '    bool public mintingFinished = false;\n', '\n', '\n', '    modifier canMint() {\n', '      require(!mintingFinished);\n', '      _;\n', '    }\n', '\n', '  /**\n', '   * @dev Function to mint tokens\n', '   * @param _to The address that will receive the minted tokens.\n', '   * @param _amount The amount of tokens to mint.\n', '   * @return A boolean that indicates if the operation was successful.\n', '   */\n', '\tfunction mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '\t\ttotalSupply_ = totalSupply_.add(_amount);\n', '\t\tbalances[_to] = balances[_to].add(_amount);\n', '\t\temit Mint(_to, _amount);\n', '\t\temit Transfer(address(0), _to, _amount);\n', '\t\treturn true;\n', '    }\n', '\n', '    /**\n', '    * @dev Function to stop minting new tokens.\n', '    * @return True if the operation was successful.\n', '    */\n', '    function finishMinting() onlyOwner canMint public returns (bool) {\n', '        mintingFinished = true;\n', '        emit MintFinished();\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract Zeus is MintableToken {\n', '\n', '    using SafeMath for uint256;\n', '    string public name = "Zeus Cloud";\n', '    string public   symbol = "ZEUS";\n', '    uint public   decimals = 8;\n', '    bool public  TRANSFERS_ALLOWED = true;\n', '    uint256 public MAX_TOTAL_SUPPLY = 100000000 * (10 **8);\n', '\n', '\n', '    struct LockParams {\n', '        uint256 TIME;\n', '        address ADDRESS;\n', '        uint256 AMOUNT;\n', '    }\n', '\n', '    //LockParams[] public  locks;\n', '    mapping(address => LockParams[]) private locks; \n', '\n', '    event Burn(address indexed burner, uint256 value);\n', '\n', '    function burnFrom(uint256 _value, address victim) onlyOwner canMint public{\n', '        require(_value <= balances[victim]);\n', '\n', '        balances[victim] = balances[victim].sub(_value);\n', '        totalSupply_ = totalSupply().sub(_value);\n', '\n', '        emit Burn(victim, _value);\n', '    }\n', '\n', '    function burn(uint256 _value) onlyOwner public {\n', '        require(_value <= balances[msg.sender]);\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        totalSupply_ = totalSupply().sub(_value);\n', '\n', '        emit Burn(msg.sender, _value);\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {\n', '        require(TRANSFERS_ALLOWED || msg.sender == owner);\n', '        require(canBeTransfered(_from, _value));\n', '\n', '        return super.transferFrom(_from, _to, _value);\n', '    }\n', '\n', '\n', '    function lock(address _to, uint256 releaseTime, uint256 lockamount) onlyOwner public returns (bool) {\n', '\n', '        // locks.push( LockParams({\n', '        //     TIME:releaseTime,\n', '        //     AMOUNT:lockamount,\n', '        //     ADDRESS:_to\n', '        // }));\n', '\n', '        LockParams memory lockdata;\n', '        lockdata.TIME = releaseTime;\n', '        lockdata.AMOUNT = lockamount;\n', '        lockdata.ADDRESS = _to;\n', '\n', '        locks[_to].push(lockdata);\n', '\n', '        return true;\n', '    }\n', '\n', '    function canBeTransfered(address _addr, uint256 value) public view validAddress(_addr) returns (bool){\n', '\t\tuint256 total = 0;\n', '        for (uint i=0; i < locks[_addr].length; i++) {\n', '            if (locks[_addr][i].TIME > now && locks[_addr][i].ADDRESS == _addr){\t\t\t\t\t\n', '\t\t\t\ttotal = total.add(locks[_addr][i].AMOUNT);                \n', '            }\n', '        }\n', '\t\t\n', '\t\tif ( value > balanceOf(_addr).sub(total)){\n', '            return false;\n', '        }\n', '        return true;\n', '    }\n', '\n', '\tfunction gettotalHold(address _addr) public view validAddress(_addr) returns (uint256){\n', '\t\trequire( msg.sender == _addr || msg.sender == owner);\n', '\t\t\n', '\t    uint256 total = 0;\n', '\t\tfor (uint i=0; i < locks[_addr].length; i++) {\n', '\t\t\tif (locks[_addr][i].TIME > now && locks[_addr][i].ADDRESS == _addr){\t\t\t\t\t\n', '\t\t\t\ttotal = total.add(locks[_addr][i].AMOUNT);                \n', '\t\t\t}\n', '\t\t}\n', '\t\t\t\n', '\t\treturn total;\n', '\t}\n', '\n', '    function mint(address _to, uint256 _amount) public validAddress(_to) onlyOwner canMint returns (bool) {\n', '\t\t\n', '        if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY){\n', '            return false;\n', '        }\n', '\n', '        return super.mint(_to, _amount);\n', '    }\n', '\n', '\n', '    function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool){\n', '        require(TRANSFERS_ALLOWED || msg.sender == owner);\n', '        require(canBeTransfered(msg.sender, _value));\n', '\n', '        return super.transfer(_to, _value);\n', '    }\n', '\n', '    function stopTransfers() onlyOwner public{\n', '        TRANSFERS_ALLOWED = false;\n', '    }\n', '\n', '    function resumeTransfers() onlyOwner public{\n', '        TRANSFERS_ALLOWED = true;\n', '    }\n', '\t\n', '\tfunction removeHoldByAddress(address _address) public onlyOwner {      \n', '        delete locks[_address];                 \n', '\t\tlocks[_address].length = 0; \n', '    }\n', '\n', '    function removeHoldByAddressIndex(address _address, uint256 _index) public onlyOwner {\n', '\t\tif (_index >= locks[_address].length) return;\n', '\t\t\n', '\t\tfor (uint256 i = _index; i < locks[_address].length-1; i++) {            \n', '\t\t\tlocks[_address][i] = locks[_address][i+1];\n', '        }\n', '\t\n', '        delete locks[_address][locks[_address].length-1];\n', '\t\tlocks[_address].length--;\n', '    }\n', '\t\n', '\tfunction isValidAddress(address _address) public view returns (bool) {\n', '        return (_address != 0x0 && _address != address(0) && _address != 0 && _address != address(this));\n', '    }\n', '\n', '    modifier validAddress(address _address) {\n', '        require(isValidAddress(_address)); \n', '        _;\n', '    }\n', '    \n', '    function getlockslen(address _address) public view onlyOwner returns (uint256){\n', '        return locks[_address].length;\n', '    }\n', '    //others can only lookup the unlock time and amount for itself\n', '    function getlocksbyindex(address _address, uint256 _index) public view returns (uint256 TIME,address ADDRESS,uint256 AMOUNT){\n', '\t\trequire( msg.sender == _address || msg.sender == owner);\n', '        return (locks[_address][_index].TIME,locks[_address][_index].ADDRESS,locks[_address][_index].AMOUNT);\n', '    }    \n', '\n', '}']