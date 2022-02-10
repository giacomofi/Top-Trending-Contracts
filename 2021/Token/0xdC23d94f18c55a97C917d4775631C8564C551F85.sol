['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable()  public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal view returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal view returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal view returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal view returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances.\n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '\n', '  /**\n', '  * @dev transfer token for a specified address\n', '  * @param _to The address to transfer to.\n', '  * @param _value The amount to be transferred.\n', '  */\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    // SafeMath.sub will throw if there is not enough balance.\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address.\n', '  * @param _owner The address to query the the balance of.\n', '  * @return An uint256 representing the amount owned by the passed address.\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Standard ERC20 token\n', ' *\n', ' * @dev Implementation of the basic standard token.\n', ' * @dev https://github.com/ethereum/EIPs/issues/20\n', ' * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol\n', ' */\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(_to != address(0));\n', '\n', '    uint256 _allowance = allowed[_from][msg.sender];\n', '\n', '    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '    // require (_value <= _allowance);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '   *\n', '   * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', "   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:\n", '   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  /**\n', '   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '   * @param _owner address The address which owns the funds.\n', '   * @param _spender address The address which will spend the funds.\n', '   * @return A uint256 specifying the amount of tokens still available for the spender.\n', '   */\n', '  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '\n', '  /**\n', '   * approve should be called when allowed[_spender] == 0. To increment\n', '   * allowed value is better to use this function to avoid 2 calls (and wait until\n', '   * the first transaction is mined)\n', '   * From MonolithDAO Token.sol\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {\n', '    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {\n', '    uint oldValue = allowed[msg.sender][_spender];\n', '    if (_subtractedValue > oldValue) {\n', '      allowed[msg.sender][_spender] = 0;\n', '    } else {\n', '      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '    }\n', '    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '    return true;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Element Token\n', ' * @dev ERC20 Element Token)\n', ' *\n', ' * All initial tokens are assigned to the creator of\n', ' * this contract.\n', ' *\n', ' */\n', 'contract ElementToken is StandardToken, Pausable {\n', '\n', '  string public name = "";               // Set the token name for display\n', '  string public symbol = "";             // Set the token symbol for display\n', '  uint8 public decimals = 0;             // Set the token symbol for display\n', '\n', '  /**\n', "   * @dev Don't allow tokens to be sent to the contract\n", '   */\n', '  modifier rejectTokensToContract(address _to) {\n', '    require(_to != address(this));\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev ElementToken Constructor\n', '   * Runs only on initial contract creation.\n', '   */\n', '  function ElementToken(string _name, string _symbol, uint256 _tokens, uint8 _decimals)  public {\n', '    name = _name;\n', '    symbol = _symbol;\n', '    decimals = _decimals;\n', '    totalSupply = _tokens * 10**uint256(decimals);          // Set the total supply\n', '    balances[msg.sender] = totalSupply;                      // Creator address is assigned all\n', '    Transfer(0x0, msg.sender, totalSupply);                  // create Transfer event for minting\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer token for a specified address when not paused\n', '   * @param _to The address to transfer to.\n', '   * @param _value The amount to be transferred.\n', '   */\n', '  function transfer(address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfer tokens from one address to another when not paused\n', '   * @param _from address The address which you want to send tokens from\n', '   * @param _to address The address which you want to transfer to\n', '   * @param _value uint256 the amount of tokens to be transferred\n', '   */\n', '  function transferFrom(address _from, address _to, uint256 _value) rejectTokensToContract(_to) public whenNotPaused returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  /**\n', '   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.\n', '   * @param _spender The address which will spend the funds.\n', '   * @param _value The amount of tokens to be spent.\n', '   */\n', '  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  /**\n', '   * Adding whenNotPaused\n', '   */\n', '  function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {\n', '    return super.increaseApproval(_spender, _addedValue);\n', '  }\n', '\n', '  /**\n', '   * Adding whenNotPaused\n', '   */\n', '  function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {\n', '    return super.decreaseApproval(_spender, _subtractedValue);\n', '  }\n', '\n', '}\n', '\n', 'contract Multiownable {\n', '\n', '    // VARIABLES\n', '\n', '    uint256 public ownersGeneration;\n', '    uint256 public howManyOwnersDecide;\n', '    address[] public owners;\n', '    bytes32[] public allOperations;\n', '    address internal insideCallSender;\n', '    uint256 internal insideCallCount;\n', '\n', '    // Reverse lookup tables for owners and allOperations\n', '    mapping(address => uint) public ownersIndices; // Starts from 1\n', '    mapping(bytes32 => uint) public allOperationsIndicies;\n', '\n', '    // Owners voting mask per operations\n', '    mapping(bytes32 => uint256) public votesMaskByOperation;\n', '    mapping(bytes32 => uint256) public votesCountByOperation;\n', '\n', '    // EVENTS\n', '\n', '    event OwnershipTransferred(address[] previousOwners, uint howManyOwnersDecide, address[] newOwners, uint newHowManyOwnersDecide);\n', '    event OperationCreated(bytes32 operation, uint howMany, uint ownersCount, address proposer);\n', '    event OperationUpvoted(bytes32 operation, uint votes, uint howMany, uint ownersCount, address upvoter);\n', '    event OperationPerformed(bytes32 operation, uint howMany, uint ownersCount, address performer);\n', '    event OperationDownvoted(bytes32 operation, uint votes, uint ownersCount,  address downvoter);\n', '    event OperationCancelled(bytes32 operation, address lastCanceller);\n', '    \n', '    // ACCESSORS\n', '\n', '    function isOwner(address wallet) public view returns(bool) {\n', '        return ownersIndices[wallet] > 0;\n', '    }\n', '\n', '    function ownersCount() public view returns(uint) {\n', '        return owners.length;\n', '    }\n', '\n', '    function allOperationsCount() public view returns(uint) {\n', '        return allOperations.length;\n', '    }\n', '\n', '    // MODIFIERS\n', '\n', '    /**\n', '    * @dev Allows to perform method by any of the owners\n', '    */\n', '    modifier onlyAnyOwner {\n', '        if (checkHowManyOwners(1)) {\n', '            bool update = (insideCallSender == address(0));\n', '            if (update) {\n', '                insideCallSender = msg.sender;\n', '                insideCallCount = 1;\n', '            }\n', '            _;\n', '            if (update) {\n', '                insideCallSender = address(0);\n', '                insideCallCount = 0;\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Allows to perform method only after many owners call it with the same arguments\n', '    */\n', '    modifier onlyManyOwners {\n', '        if (checkHowManyOwners(howManyOwnersDecide)) {\n', '            bool update = (insideCallSender == address(0));\n', '            if (update) {\n', '                insideCallSender = msg.sender;\n', '                insideCallCount = howManyOwnersDecide;\n', '            }\n', '            _;\n', '            if (update) {\n', '                insideCallSender = address(0);\n', '                insideCallCount = 0;\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Allows to perform method only after all owners call it with the same arguments\n', '    */\n', '    modifier onlyAllOwners {\n', '        if (checkHowManyOwners(owners.length)) {\n', '            bool update = (insideCallSender == address(0));\n', '            if (update) {\n', '                insideCallSender = msg.sender;\n', '                insideCallCount = owners.length;\n', '            }\n', '            _;\n', '            if (update) {\n', '                insideCallSender = address(0);\n', '                insideCallCount = 0;\n', '            }\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Allows to perform method only after some owners call it with the same arguments\n', '    */\n', '    modifier onlySomeOwners(uint howMany) {\n', '        require(howMany > 0, "onlySomeOwners: howMany argument is zero");\n', '        require(howMany <= owners.length, "onlySomeOwners: howMany argument exceeds the number of owners");\n', '        \n', '        if (checkHowManyOwners(howMany)) {\n', '            bool update = (insideCallSender == address(0));\n', '            if (update) {\n', '                insideCallSender = msg.sender;\n', '                insideCallCount = howMany;\n', '            }\n', '            _;\n', '            if (update) {\n', '                insideCallSender = address(0);\n', '                insideCallCount = 0;\n', '            }\n', '        }\n', '    }\n', '\n', '    // CONSTRUCTOR\n', '\n', '    constructor() public {\n', '        owners.push(msg.sender);\n', '        ownersIndices[msg.sender] = 1;\n', '        howManyOwnersDecide = 1;\n', '    }\n', '\n', '    // INTERNAL METHODS\n', '\n', '    /**\n', '     * @dev onlyManyOwners modifier helper\n', '     */\n', '    function checkHowManyOwners(uint howMany) internal returns(bool) {\n', '        if (insideCallSender == msg.sender) {\n', '            require(howMany <= insideCallCount, "checkHowManyOwners: nested owners modifier check require more owners");\n', '            return true;\n', '        }\n', '\n', '        uint ownerIndex = ownersIndices[msg.sender] - 1;\n', '        require(ownerIndex < owners.length, "checkHowManyOwners: msg.sender is not an owner");\n', '        bytes32 operation = keccak256(abi.encodePacked(msg.data, ownersGeneration));\n', '\n', '        require((votesMaskByOperation[operation] & (2 ** ownerIndex)) == 0, "checkHowManyOwners: owner already voted for the operation");\n', '        votesMaskByOperation[operation] |= (2 ** ownerIndex);\n', '        uint operationVotesCount = votesCountByOperation[operation] + 1;\n', '        votesCountByOperation[operation] = operationVotesCount;\n', '        if (operationVotesCount == 1) {\n', '            allOperationsIndicies[operation] = allOperations.length;\n', '            allOperations.push(operation);\n', '            emit OperationCreated(operation, howMany, owners.length, msg.sender);\n', '        }\n', '        emit OperationUpvoted(operation, operationVotesCount, howMany, owners.length, msg.sender);\n', '\n', '        // If enough owners confirmed the same operation\n', '        if (votesCountByOperation[operation] == howMany) {\n', '            deleteOperation(operation);\n', '            emit OperationPerformed(operation, howMany, owners.length, msg.sender);\n', '            return true;\n', '        }\n', '\n', '        return false;\n', '    }\n', '\n', '    /**\n', '    * @dev Used to delete cancelled or performed operation\n', '    * @param operation defines which operation to delete\n', '    */\n', '    function deleteOperation(bytes32 operation) internal {\n', '        uint index = allOperationsIndicies[operation];\n', '        if (index < allOperations.length - 1) { // Not last\n', '            allOperations[index] = allOperations[allOperations.length - 1];\n', '            allOperationsIndicies[allOperations[index]] = index;\n', '        }\n', '        //allOperations.length-1\n', '        allOperations.push(allOperations[allOperations.length-1]);\n', '\n', '        delete votesMaskByOperation[operation];\n', '        delete votesCountByOperation[operation];\n', '        delete allOperationsIndicies[operation];\n', '    }\n', '\n', '    // PUBLIC METHODS\n', '\n', '    /**\n', '    * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations\n', '    * @param operation defines which operation to delete\n', '    */\n', '    function cancelPending(bytes32 operation) public onlyAnyOwner {\n', '        uint ownerIndex = ownersIndices[msg.sender] - 1;\n', '        require((votesMaskByOperation[operation] & (2 ** ownerIndex)) != 0, "cancelPending: operation not found for this user");\n', '        votesMaskByOperation[operation] &= ~(2 ** ownerIndex);\n', '        uint operationVotesCount = votesCountByOperation[operation] - 1;\n', '        votesCountByOperation[operation] = operationVotesCount;\n', '        emit OperationDownvoted(operation, operationVotesCount, owners.length, msg.sender);\n', '        if (operationVotesCount == 0) {\n', '            deleteOperation(operation);\n', '            emit OperationCancelled(operation, msg.sender);\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Allows owners to change ownership\n', '    * @param newOwners defines array of addresses of new owners\n', '    */\n', '    function transferOwnership(address[] memory newOwners) public {\n', '        transferOwnershipWithHowMany(newOwners, newOwners.length);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows owners to change ownership\n', '    * @param newOwners defines array of addresses of new owners\n', '    * @param newHowManyOwnersDecide defines how many owners can decide\n', '    */\n', '    function transferOwnershipWithHowMany(address[] memory newOwners, uint256 newHowManyOwnersDecide) public onlyManyOwners {\n', '        require(newOwners.length > 0, "transferOwnershipWithHowMany: owners array is empty");\n', '        require(newOwners.length <= 256, "transferOwnershipWithHowMany: owners count is greater then 256");\n', '        require(newHowManyOwnersDecide > 0, "transferOwnershipWithHowMany: newHowManyOwnersDecide equal to 0");\n', '        require(newHowManyOwnersDecide <= newOwners.length, "transferOwnershipWithHowMany: newHowManyOwnersDecide exceeds the number of owners");\n', '\n', '        // Reset owners reverse lookup table\n', '        for (uint j = 0; j < owners.length; j++) {\n', '            delete ownersIndices[owners[j]];\n', '        }\n', '        for (uint i = 0; i < newOwners.length; i++) {\n', '            require(newOwners[i] != address(0), "transferOwnershipWithHowMany: owners array contains zero");\n', '            require(ownersIndices[newOwners[i]] == 0, "transferOwnershipWithHowMany: owners array contains duplicates");\n', '            ownersIndices[newOwners[i]] = i + 1;\n', '        }\n', '        \n', '        emit OwnershipTransferred(owners, howManyOwnersDecide, newOwners, newHowManyOwnersDecide);\n', '        owners = newOwners;\n', '        howManyOwnersDecide = newHowManyOwnersDecide;\n', '        // allOperations.length = 0;\n', '        allOperations.push(allOperations[0]);\n', '        ownersGeneration++;\n', '    }\n', '\n', '}\n', '\n', 'contract ethBridge is Multiownable {\n', '    ElementToken private token;\n', '\n', '    mapping(address => uint256) public tokensSent;\n', '    mapping(address => uint256) public tokensRecieved;\n', '    mapping(address => uint256) public tokensRecievedButNotSent;\n', ' \n', '    constructor (address _token) public {\n', '        token = ElementToken(_token);\n', '    }\n', ' \n', '    uint256 amountToSent;\n', '    bool transferStatus;\n', '    \n', '    bool avoidReentrancy = false;\n', ' \n', '    function sendTokens(uint256 amount) public {\n', '        require(msg.sender != address(0), "Zero account");\n', '        require(amount > 0,"Amount of tokens should be more then 0");\n', '        require(token.balanceOf(msg.sender) >= amount,"Not enough balance");\n', '        \n', '        transferStatus = token.transferFrom(msg.sender, address(this), amount);\n', '        if (transferStatus == true) {\n', '            tokensRecieved[msg.sender] += amount;\n', '        }\n', '    }\n', ' \n', '    function writeTransaction(address user, uint256 amount) public onlyAllOwners {\n', '        require(user != address(0), "Zero account");\n', '        require(amount > 0,"Amount of tokens should be more then 0");\n', '        require(!avoidReentrancy);\n', '        \n', '        avoidReentrancy = true;\n', '        tokensRecievedButNotSent[user] += amount;\n', '        avoidReentrancy = false;\n', '    }\n', '\n', '    function recieveTokens(uint256[] memory commissions) public payable {\n', '        if (tokensRecievedButNotSent[msg.sender] != 0) {\n', '            require(commissions.length == owners.length, "The number of commissions and owners does not match");\n', '            uint256 sum;\n', '            for(uint i = 0; i < commissions.length; i++) {\n', '                sum += commissions[i];\n', '            }\n', '            require(msg.value >= sum, "Not enough ETH (The amount of ETH is less than the amount of commissions.)");\n', '            require(msg.value >= owners.length * 150000 * 10**9, "Not enough ETH (The amount of ETH is less than the internal commission.)");\n', '        \n', '            for (i = 0; i < owners.length; i++) {\n', '                uint256 commission = commissions[i];\n', '                owners[i].transfer(commission);\n', '            }\n', '            \n', '            amountToSent = tokensRecievedButNotSent[msg.sender] - tokensSent[msg.sender];\n', '            token.transfer(msg.sender, amountToSent);\n', '            tokensSent[msg.sender] += amountToSent;\n', '        }\n', '    }\n', ' \n', '    function withdrawTokens(uint256 amount, address reciever) public onlyAllOwners {\n', '        require(amount > 0,"Amount of tokens should be more then 0");\n', '        require(reciever != address(0), "Zero account");\n', '        require(token.balanceOf(address(this)) >= amount,"Not enough balance");\n', '        \n', '        token.transfer(reciever, amount);\n', '    }\n', '    \n', '    function withdrawEther(uint256 amount, address reciever) public onlyAllOwners {\n', '        require(amount > 0,"Amount of tokens should be more then 0");\n', '        require(reciever != address(0), "Zero account");\n', '        require(address(this).balance >= amount,"Not enough balance");\n', '\n', '        reciever.transfer(amount);\n', '    }\n', '}']