['pragma solidity ^0.4.23;\n', '\n', 'contract ERC223Interface {\n', '    uint public totalSupply;\n', '    uint8 public decimals;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function transfer(address to, uint value);\n', '    function transfer(address to, uint value, bytes data);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title AirDropContract\n', ' * Simply do the airdrop.\n', ' */\n', 'contract AirDropForERC223 is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // the amount that owner wants to send each time\n', '    uint public airDropAmount;\n', '\n', '    // the mapping to judge whether each address has already received airDropped\n', '    mapping ( address => bool ) public invalidAirDrop;\n', '\n', '    // the array of addresses which received airDrop\n', '    address[] public arrayAirDropReceivers;\n', '\n', '    // flag to stop airdrop\n', '    bool public stop = false;\n', '\n', '    ERC223Interface public erc20;\n', '\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // event\n', '    event LogAirDrop(address indexed receiver, uint amount);\n', '    event LogStop();\n', '    event LogStart();\n', '    event LogWithdrawal(address indexed receiver, uint amount);\n', '    event LogInfoUpdate(uint256 startTime, uint256 endTime, uint256 airDropAmount);\n', '\n', '    /**\n', '    * @dev Constructor to set _airDropAmount and _tokenAddresss.\n', '    * @param _airDropAmount The amount of token that is sent for doing airDrop.\n', '    * @param _tokenAddress The address of token.\n', '    */\n', '    constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {\n', '        require(_startTime >= now &&\n', '            _endTime >= _startTime &&\n', '            _airDropAmount > 0 &&\n', '            _tokenAddress != address(0)\n', '        );\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        erc20 = ERC223Interface(_tokenAddress);\n', '        uint tokenDecimals = erc20.decimals();\n', '        airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);\n', '    }\n', '\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) {}\n', '\n', '    /**\n', '    * @dev Confirm that airDrop is available.\n', '    * @return A bool to confirm that airDrop is available.\n', '    */\n', '    function isValidAirDropForAll() public view returns (bool) {\n', '        bool validNotStop = !stop;\n', '        bool validAmount = getRemainingToken() >= airDropAmount;\n', '        bool validPeriod = now >= startTime && now <= endTime;\n', '        return validNotStop && validAmount && validPeriod;\n', '    }\n', '\n', '    /**\n', '    * @dev Confirm that airDrop is available for msg.sender.\n', '    * @return A bool to confirm that airDrop is available for msg.sender.\n', '    */\n', '    function isValidAirDropForIndividual() public view returns (bool) {\n', '        bool validNotStop = !stop;\n', '        bool validAmount = getRemainingToken() >= airDropAmount;\n', '        bool validPeriod = now >= startTime && now <= endTime;\n', '        bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];\n', '        return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;\n', '    }\n', '\n', '    /**\n', '    * @dev Do the airDrop to msg.sender\n', '    */\n', '    function receiveAirDrop() public {\n', '        require(isValidAirDropForIndividual());\n', '\n', '        // set invalidAirDrop of msg.sender to true\n', '        invalidAirDrop[msg.sender] = true;\n', '\n', '        // set msg.sender to the array of the airDropReceiver\n', '        arrayAirDropReceivers.push(msg.sender);\n', '\n', '        // execute transfer\n', '        erc20.transfer(msg.sender, airDropAmount);\n', '\n', '        emit LogAirDrop(msg.sender, airDropAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Change the state of stop flag\n', '    */\n', '    function toggle() public onlyOwner {\n', '        stop = !stop;\n', '\n', '        if (stop) {\n', '            emit LogStop();\n', '        } else {\n', '            emit LogStart();\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Withdraw the amount of token that is remaining in this contract.\n', '    * @param _address The address of EOA that can receive token from this contract.\n', '    */\n', '    function withdraw(address _address) public onlyOwner {\n', '        require(stop || now > endTime);\n', '        require(_address != address(0));\n', '        uint tokenBalanceOfContract = getRemainingToken();\n', '        erc20.transfer(_address, tokenBalanceOfContract);\n', '        emit LogWithdrawal(_address, tokenBalanceOfContract);\n', '    }\n', '\n', '    /**\n', '    * @dev Update the information regarding to period and amount.\n', '    * @param _startTime The start time this airdrop starts.\n', '    * @param _endTime The end time this sirdrop ends.\n', '    * @param _airDropAmount The airDrop Amount that user can get via airdrop.\n', '    */\n', '    function updateInfo(uint256 _startTime, uint256 _endTime, uint256 _airDropAmount) public onlyOwner {\n', '        require(stop || now > endTime);\n', '        require(\n', '            _startTime >= now &&\n', '            _endTime >= _startTime &&\n', '            _airDropAmount > 0\n', '        );\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        uint tokenDecimals = erc20.decimals();\n', '        airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);\n', '\n', '        emit LogInfoUpdate(startTime, endTime, airDropAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Get the total number of addresses which received airDrop.\n', '    * @return Uint256 the total number of addresses which received airDrop.\n', '    */\n', '    function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {\n', '        return arrayAirDropReceivers.length;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the remaining amount of token user can receive.\n', '    * @return Uint256 the amount of token that user can reveive.\n', '    */\n', '    function getRemainingToken() public view returns (uint256) {\n', '        return erc20.balanceOf(this);\n', '    }\n', '\n', '    /**\n', '    * @dev Return the total amount of token user received.\n', '    * @return Uint256 total amount of token user received.\n', '    */\n', '    function getTotalAirDroppedAmount() public view returns (uint256) {\n', '        return airDropAmount.mul(arrayAirDropReceivers.length);\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'contract ERC223Interface {\n', '    uint public totalSupply;\n', '    uint8 public decimals;\n', '    function balanceOf(address who) constant returns (uint);\n', '    function transfer(address to, uint value);\n', '    function transfer(address to, uint value, bytes data);\n', '    event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', 'contract ERC223ReceivingContract {\n', '    \n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data);\n', '}\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '    c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title AirDropContract\n', ' * Simply do the airdrop.\n', ' */\n', 'contract AirDropForERC223 is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    // the amount that owner wants to send each time\n', '    uint public airDropAmount;\n', '\n', '    // the mapping to judge whether each address has already received airDropped\n', '    mapping ( address => bool ) public invalidAirDrop;\n', '\n', '    // the array of addresses which received airDrop\n', '    address[] public arrayAirDropReceivers;\n', '\n', '    // flag to stop airdrop\n', '    bool public stop = false;\n', '\n', '    ERC223Interface public erc20;\n', '\n', '    uint256 public startTime;\n', '    uint256 public endTime;\n', '\n', '    // event\n', '    event LogAirDrop(address indexed receiver, uint amount);\n', '    event LogStop();\n', '    event LogStart();\n', '    event LogWithdrawal(address indexed receiver, uint amount);\n', '    event LogInfoUpdate(uint256 startTime, uint256 endTime, uint256 airDropAmount);\n', '\n', '    /**\n', '    * @dev Constructor to set _airDropAmount and _tokenAddresss.\n', '    * @param _airDropAmount The amount of token that is sent for doing airDrop.\n', '    * @param _tokenAddress The address of token.\n', '    */\n', '    constructor(uint256 _startTime, uint256 _endTime, uint _airDropAmount, address _tokenAddress) public {\n', '        require(_startTime >= now &&\n', '            _endTime >= _startTime &&\n', '            _airDropAmount > 0 &&\n', '            _tokenAddress != address(0)\n', '        );\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        erc20 = ERC223Interface(_tokenAddress);\n', '        uint tokenDecimals = erc20.decimals();\n', '        airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);\n', '    }\n', '\n', '    /**\n', '     * @dev Standard ERC223 function that will handle incoming token transfers.\n', '     *\n', '     * @param _from  Token sender address.\n', '     * @param _value Amount of tokens.\n', '     * @param _data  Transaction metadata.\n', '     */\n', '    function tokenFallback(address _from, uint _value, bytes _data) {}\n', '\n', '    /**\n', '    * @dev Confirm that airDrop is available.\n', '    * @return A bool to confirm that airDrop is available.\n', '    */\n', '    function isValidAirDropForAll() public view returns (bool) {\n', '        bool validNotStop = !stop;\n', '        bool validAmount = getRemainingToken() >= airDropAmount;\n', '        bool validPeriod = now >= startTime && now <= endTime;\n', '        return validNotStop && validAmount && validPeriod;\n', '    }\n', '\n', '    /**\n', '    * @dev Confirm that airDrop is available for msg.sender.\n', '    * @return A bool to confirm that airDrop is available for msg.sender.\n', '    */\n', '    function isValidAirDropForIndividual() public view returns (bool) {\n', '        bool validNotStop = !stop;\n', '        bool validAmount = getRemainingToken() >= airDropAmount;\n', '        bool validPeriod = now >= startTime && now <= endTime;\n', '        bool validReceiveAirDropForIndividual = !invalidAirDrop[msg.sender];\n', '        return validNotStop && validAmount && validPeriod && validReceiveAirDropForIndividual;\n', '    }\n', '\n', '    /**\n', '    * @dev Do the airDrop to msg.sender\n', '    */\n', '    function receiveAirDrop() public {\n', '        require(isValidAirDropForIndividual());\n', '\n', '        // set invalidAirDrop of msg.sender to true\n', '        invalidAirDrop[msg.sender] = true;\n', '\n', '        // set msg.sender to the array of the airDropReceiver\n', '        arrayAirDropReceivers.push(msg.sender);\n', '\n', '        // execute transfer\n', '        erc20.transfer(msg.sender, airDropAmount);\n', '\n', '        emit LogAirDrop(msg.sender, airDropAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Change the state of stop flag\n', '    */\n', '    function toggle() public onlyOwner {\n', '        stop = !stop;\n', '\n', '        if (stop) {\n', '            emit LogStop();\n', '        } else {\n', '            emit LogStart();\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Withdraw the amount of token that is remaining in this contract.\n', '    * @param _address The address of EOA that can receive token from this contract.\n', '    */\n', '    function withdraw(address _address) public onlyOwner {\n', '        require(stop || now > endTime);\n', '        require(_address != address(0));\n', '        uint tokenBalanceOfContract = getRemainingToken();\n', '        erc20.transfer(_address, tokenBalanceOfContract);\n', '        emit LogWithdrawal(_address, tokenBalanceOfContract);\n', '    }\n', '\n', '    /**\n', '    * @dev Update the information regarding to period and amount.\n', '    * @param _startTime The start time this airdrop starts.\n', '    * @param _endTime The end time this sirdrop ends.\n', '    * @param _airDropAmount The airDrop Amount that user can get via airdrop.\n', '    */\n', '    function updateInfo(uint256 _startTime, uint256 _endTime, uint256 _airDropAmount) public onlyOwner {\n', '        require(stop || now > endTime);\n', '        require(\n', '            _startTime >= now &&\n', '            _endTime >= _startTime &&\n', '            _airDropAmount > 0\n', '        );\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        uint tokenDecimals = erc20.decimals();\n', '        airDropAmount = _airDropAmount.mul(10 ** tokenDecimals);\n', '\n', '        emit LogInfoUpdate(startTime, endTime, airDropAmount);\n', '    }\n', '\n', '    /**\n', '    * @dev Get the total number of addresses which received airDrop.\n', '    * @return Uint256 the total number of addresses which received airDrop.\n', '    */\n', '    function getTotalNumberOfAddressesReceivedAirDrop() public view returns (uint256) {\n', '        return arrayAirDropReceivers.length;\n', '    }\n', '\n', '    /**\n', '    * @dev Get the remaining amount of token user can receive.\n', '    * @return Uint256 the amount of token that user can reveive.\n', '    */\n', '    function getRemainingToken() public view returns (uint256) {\n', '        return erc20.balanceOf(this);\n', '    }\n', '\n', '    /**\n', '    * @dev Return the total amount of token user received.\n', '    * @return Uint256 total amount of token user received.\n', '    */\n', '    function getTotalAirDroppedAmount() public view returns (uint256) {\n', '        return airDropAmount.mul(arrayAirDropReceivers.length);\n', '    }\n', '}']
