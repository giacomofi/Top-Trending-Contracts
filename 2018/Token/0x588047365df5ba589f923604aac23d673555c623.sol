['pragma solidity ^0.4.19;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/NaviToken.sol\n', '\n', 'contract NaviToken is StandardToken, Ownable {\n', '    event AssignmentStopped();\n', '    event Frosted(address indexed to, uint256 amount, uint256 defrostClass);\n', '    event Defrosted(address indexed to, uint256 amount, uint256 defrostClass);\n', '\n', '\tusing SafeMath for uint256;\n', '\n', '    /* Overriding some ERC20 variables */\n', '    string public constant name      = "NaviToken";\n', '    string public constant symbol    = "NAVI";\n', '    uint8 public constant decimals   = 18;\n', '\n', '    uint256 public constant MAX_NUM_NAVITOKENS    = 1000000000 * 10 ** uint256(decimals);\n', '    uint256 public constant START_ICO_TIMESTAMP   = 1519912800;  // TODO: line to uncomment for the PROD before the main net deployment\n', '    //uint256 public START_ICO_TIMESTAMP; // TODO: !!! line to remove before the main net deployment (not constant for testing and overwritten in the constructor)\n', '\n', '    uint256 public constant MONTH_IN_MINUTES = 43200; // month in minutes  (1month = 43200 min)\n', '    uint256 public constant DEFROST_AFTER_MONTHS = 6;\n', '\n', '    uint256 public constant DEFROST_FACTOR_TEAMANDADV = 30;\n', '\n', '    enum DefrostClass {Contributor, ReserveAndTeam, Advisor}\n', '\n', '    // Fields that can be changed by functions\n', '    address[] icedBalancesReserveAndTeam;\n', '    mapping (address => uint256) mapIcedBalancesReserveAndTeamFrosted;\n', '    mapping (address => uint256) mapIcedBalancesReserveAndTeamDefrosted;\n', '\n', '    address[] icedBalancesAdvisors;\n', '    mapping (address => uint256) mapIcedBalancesAdvisors;\n', '\n', '    //Boolean to allow or not the initial assignement of token (batch)\n', '    bool public batchAssignStopped = false;\n', '\n', '    modifier canAssign() {\n', '        require(!batchAssignStopped);\n', '        require(elapsedMonthsFromICOStart() < 2);\n', '        _;\n', '    }\n', '\n', '    function NaviToken() public {\n', '        // for test only: set START_ICO to contract creation timestamp\n', '        //START_ICO_TIMESTAMP = now; // TODO: line to remove before the main net deployment\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens in batches (of addresses)\n', '    * @param _addr address The address which you want to send tokens from\n', '    * @param _amounts address The address which you want to transfer to\n', '    */\n', '    function batchAssignTokens(address[] _addr, uint256[] _amounts, DefrostClass[] _defrostClass) public onlyOwner canAssign {\n', '        require(_addr.length == _amounts.length && _addr.length == _defrostClass.length);\n', '        //Looping into input arrays to assign target amount to each given address\n', '        for (uint256 index = 0; index < _addr.length; index++) {\n', '            address toAddress = _addr[index];\n', '            uint amount = _amounts[index];\n', '            DefrostClass defrostClass = _defrostClass[index]; // 0 = ico contributor, 1 = reserve and team , 2 = advisor\n', '\n', '            totalSupply = totalSupply.add(amount);\n', '            require(totalSupply <= MAX_NUM_NAVITOKENS);\n', '\n', '            if (defrostClass == DefrostClass.Contributor) {\n', '                // contributor account\n', '                balances[toAddress] = balances[toAddress].add(amount);\n', '                Transfer(address(0), toAddress, amount);\n', '            } else if (defrostClass == DefrostClass.ReserveAndTeam) {\n', '                // Iced account. The balance is not affected here\n', '                icedBalancesReserveAndTeam.push(toAddress);\n', '                mapIcedBalancesReserveAndTeamFrosted[toAddress] = mapIcedBalancesReserveAndTeamFrosted[toAddress].add(amount);\n', '                Frosted(toAddress, amount, uint256(defrostClass));\n', '            } else if (defrostClass == DefrostClass.Advisor) {\n', '                // advisors account: tokens to defrost\n', '                icedBalancesAdvisors.push(toAddress);\n', '                mapIcedBalancesAdvisors[toAddress] = mapIcedBalancesAdvisors[toAddress].add(amount);\n', '                Frosted(toAddress, amount, uint256(defrostClass));\n', '            }\n', '        }\n', '    }\n', '\n', '    function elapsedMonthsFromICOStart() view public returns (uint256) {\n', '       return (now <= START_ICO_TIMESTAMP) ? 0 : (now - START_ICO_TIMESTAMP) / 60 / MONTH_IN_MINUTES;\n', '    }\n', '\n', '    function canDefrostReserveAndTeam() view public returns (bool) {\n', '        return elapsedMonthsFromICOStart() > DEFROST_AFTER_MONTHS;\n', '    }\n', '\n', '    function defrostReserveAndTeamTokens() public {\n', '        require(canDefrostReserveAndTeam());\n', '\n', '        uint256 monthsIndex = elapsedMonthsFromICOStart() - DEFROST_AFTER_MONTHS;\n', '\n', '        if (monthsIndex > DEFROST_FACTOR_TEAMANDADV){\n', '            monthsIndex = DEFROST_FACTOR_TEAMANDADV;\n', '        }\n', '\n', '        // Looping into the iced accounts\n', '        for (uint256 index = 0; index < icedBalancesReserveAndTeam.length; index++) {\n', '\n', '            address currentAddress = icedBalancesReserveAndTeam[index];\n', '            uint256 amountTotal = mapIcedBalancesReserveAndTeamFrosted[currentAddress].add(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);\n', '            uint256 targetDefrosted = monthsIndex.mul(amountTotal).div(DEFROST_FACTOR_TEAMANDADV);\n', '            uint256 amountToRelease = targetDefrosted.sub(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);\n', '\n', '            if (amountToRelease > 0) {\n', '                mapIcedBalancesReserveAndTeamFrosted[currentAddress] = mapIcedBalancesReserveAndTeamFrosted[currentAddress].sub(amountToRelease);\n', '                mapIcedBalancesReserveAndTeamDefrosted[currentAddress] = mapIcedBalancesReserveAndTeamDefrosted[currentAddress].add(amountToRelease);\n', '                balances[currentAddress] = balances[currentAddress].add(amountToRelease);\n', '\n', '                Transfer(address(0), currentAddress, amountToRelease);\n', '                Defrosted(currentAddress, amountToRelease, uint256(DefrostClass.ReserveAndTeam));\n', '            }\n', '        }\n', '    }\n', '\n', '    function canDefrostAdvisors() view public returns (bool) {\n', '        return elapsedMonthsFromICOStart() >= DEFROST_AFTER_MONTHS;\n', '    }\n', '\n', '    function defrostAdvisorsTokens() public {\n', '        require(canDefrostAdvisors());\n', '        for (uint256 index = 0; index < icedBalancesAdvisors.length; index++) {\n', '            address currentAddress = icedBalancesAdvisors[index];\n', '            uint256 amountToDefrost = mapIcedBalancesAdvisors[currentAddress];\n', '            if (amountToDefrost > 0) {\n', '                balances[currentAddress] = balances[currentAddress].add(amountToDefrost);\n', '                mapIcedBalancesAdvisors[currentAddress] = mapIcedBalancesAdvisors[currentAddress].sub(amountToDefrost);\n', '\n', '                Transfer(address(0), currentAddress, amountToDefrost);\n', '                Defrosted(currentAddress, amountToDefrost, uint256(DefrostClass.Advisor));\n', '            }\n', '        }\n', '    }\n', '\n', '    function stopBatchAssign() public onlyOwner canAssign {\n', '        batchAssignStopped = true;\n', '        AssignmentStopped();\n', '    }\n', '\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '// File: zeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20Basic.sol\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/BasicToken.sol\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[msg.sender]);\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/ERC20.sol\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: zeppelin-solidity/contracts/token/StandardToken.sol\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '    require(_value <= balances[_from]);\n', '    require(_value <= allowed[_from][msg.sender]);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _addedValue The amount of tokens to increase the allowance by.\n', '   */\n', '  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '   *\n', '   * approve should be called when allowed[_spender] == 0. To decrement\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '   */\n', '  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/NaviToken.sol\n', '\n', 'contract NaviToken is StandardToken, Ownable {\n', '    event AssignmentStopped();\n', '    event Frosted(address indexed to, uint256 amount, uint256 defrostClass);\n', '    event Defrosted(address indexed to, uint256 amount, uint256 defrostClass);\n', '\n', '\tusing SafeMath for uint256;\n', '\n', '    /* Overriding some ERC20 variables */\n', '    string public constant name      = "NaviToken";\n', '    string public constant symbol    = "NAVI";\n', '    uint8 public constant decimals   = 18;\n', '\n', '    uint256 public constant MAX_NUM_NAVITOKENS    = 1000000000 * 10 ** uint256(decimals);\n', '    uint256 public constant START_ICO_TIMESTAMP   = 1519912800;  // TODO: line to uncomment for the PROD before the main net deployment\n', '    //uint256 public START_ICO_TIMESTAMP; // TODO: !!! line to remove before the main net deployment (not constant for testing and overwritten in the constructor)\n', '\n', '    uint256 public constant MONTH_IN_MINUTES = 43200; // month in minutes  (1month = 43200 min)\n', '    uint256 public constant DEFROST_AFTER_MONTHS = 6;\n', '\n', '    uint256 public constant DEFROST_FACTOR_TEAMANDADV = 30;\n', '\n', '    enum DefrostClass {Contributor, ReserveAndTeam, Advisor}\n', '\n', '    // Fields that can be changed by functions\n', '    address[] icedBalancesReserveAndTeam;\n', '    mapping (address => uint256) mapIcedBalancesReserveAndTeamFrosted;\n', '    mapping (address => uint256) mapIcedBalancesReserveAndTeamDefrosted;\n', '\n', '    address[] icedBalancesAdvisors;\n', '    mapping (address => uint256) mapIcedBalancesAdvisors;\n', '\n', '    //Boolean to allow or not the initial assignement of token (batch)\n', '    bool public batchAssignStopped = false;\n', '\n', '    modifier canAssign() {\n', '        require(!batchAssignStopped);\n', '        require(elapsedMonthsFromICOStart() < 2);\n', '        _;\n', '    }\n', '\n', '    function NaviToken() public {\n', '        // for test only: set START_ICO to contract creation timestamp\n', '        //START_ICO_TIMESTAMP = now; // TODO: line to remove before the main net deployment\n', '    }\n', '\n', '    /**\n', '    * @dev Transfer tokens in batches (of addresses)\n', '    * @param _addr address The address which you want to send tokens from\n', '    * @param _amounts address The address which you want to transfer to\n', '    */\n', '    function batchAssignTokens(address[] _addr, uint256[] _amounts, DefrostClass[] _defrostClass) public onlyOwner canAssign {\n', '        require(_addr.length == _amounts.length && _addr.length == _defrostClass.length);\n', '        //Looping into input arrays to assign target amount to each given address\n', '        for (uint256 index = 0; index < _addr.length; index++) {\n', '            address toAddress = _addr[index];\n', '            uint amount = _amounts[index];\n', '            DefrostClass defrostClass = _defrostClass[index]; // 0 = ico contributor, 1 = reserve and team , 2 = advisor\n', '\n', '            totalSupply = totalSupply.add(amount);\n', '            require(totalSupply <= MAX_NUM_NAVITOKENS);\n', '\n', '            if (defrostClass == DefrostClass.Contributor) {\n', '                // contributor account\n', '                balances[toAddress] = balances[toAddress].add(amount);\n', '                Transfer(address(0), toAddress, amount);\n', '            } else if (defrostClass == DefrostClass.ReserveAndTeam) {\n', '                // Iced account. The balance is not affected here\n', '                icedBalancesReserveAndTeam.push(toAddress);\n', '                mapIcedBalancesReserveAndTeamFrosted[toAddress] = mapIcedBalancesReserveAndTeamFrosted[toAddress].add(amount);\n', '                Frosted(toAddress, amount, uint256(defrostClass));\n', '            } else if (defrostClass == DefrostClass.Advisor) {\n', '                // advisors account: tokens to defrost\n', '                icedBalancesAdvisors.push(toAddress);\n', '                mapIcedBalancesAdvisors[toAddress] = mapIcedBalancesAdvisors[toAddress].add(amount);\n', '                Frosted(toAddress, amount, uint256(defrostClass));\n', '            }\n', '        }\n', '    }\n', '\n', '    function elapsedMonthsFromICOStart() view public returns (uint256) {\n', '       return (now <= START_ICO_TIMESTAMP) ? 0 : (now - START_ICO_TIMESTAMP) / 60 / MONTH_IN_MINUTES;\n', '    }\n', '\n', '    function canDefrostReserveAndTeam() view public returns (bool) {\n', '        return elapsedMonthsFromICOStart() > DEFROST_AFTER_MONTHS;\n', '    }\n', '\n', '    function defrostReserveAndTeamTokens() public {\n', '        require(canDefrostReserveAndTeam());\n', '\n', '        uint256 monthsIndex = elapsedMonthsFromICOStart() - DEFROST_AFTER_MONTHS;\n', '\n', '        if (monthsIndex > DEFROST_FACTOR_TEAMANDADV){\n', '            monthsIndex = DEFROST_FACTOR_TEAMANDADV;\n', '        }\n', '\n', '        // Looping into the iced accounts\n', '        for (uint256 index = 0; index < icedBalancesReserveAndTeam.length; index++) {\n', '\n', '            address currentAddress = icedBalancesReserveAndTeam[index];\n', '            uint256 amountTotal = mapIcedBalancesReserveAndTeamFrosted[currentAddress].add(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);\n', '            uint256 targetDefrosted = monthsIndex.mul(amountTotal).div(DEFROST_FACTOR_TEAMANDADV);\n', '            uint256 amountToRelease = targetDefrosted.sub(mapIcedBalancesReserveAndTeamDefrosted[currentAddress]);\n', '\n', '            if (amountToRelease > 0) {\n', '                mapIcedBalancesReserveAndTeamFrosted[currentAddress] = mapIcedBalancesReserveAndTeamFrosted[currentAddress].sub(amountToRelease);\n', '                mapIcedBalancesReserveAndTeamDefrosted[currentAddress] = mapIcedBalancesReserveAndTeamDefrosted[currentAddress].add(amountToRelease);\n', '                balances[currentAddress] = balances[currentAddress].add(amountToRelease);\n', '\n', '                Transfer(address(0), currentAddress, amountToRelease);\n', '                Defrosted(currentAddress, amountToRelease, uint256(DefrostClass.ReserveAndTeam));\n', '            }\n', '        }\n', '    }\n', '\n', '    function canDefrostAdvisors() view public returns (bool) {\n', '        return elapsedMonthsFromICOStart() >= DEFROST_AFTER_MONTHS;\n', '    }\n', '\n', '    function defrostAdvisorsTokens() public {\n', '        require(canDefrostAdvisors());\n', '        for (uint256 index = 0; index < icedBalancesAdvisors.length; index++) {\n', '            address currentAddress = icedBalancesAdvisors[index];\n', '            uint256 amountToDefrost = mapIcedBalancesAdvisors[currentAddress];\n', '            if (amountToDefrost > 0) {\n', '                balances[currentAddress] = balances[currentAddress].add(amountToDefrost);\n', '                mapIcedBalancesAdvisors[currentAddress] = mapIcedBalancesAdvisors[currentAddress].sub(amountToDefrost);\n', '\n', '                Transfer(address(0), currentAddress, amountToDefrost);\n', '                Defrosted(currentAddress, amountToDefrost, uint256(DefrostClass.Advisor));\n', '            }\n', '        }\n', '    }\n', '\n', '    function stopBatchAssign() public onlyOwner canAssign {\n', '        batchAssignStopped = true;\n', '        AssignmentStopped();\n', '    }\n', '\n', '    function() public payable {\n', '        revert();\n', '    }\n', '}']