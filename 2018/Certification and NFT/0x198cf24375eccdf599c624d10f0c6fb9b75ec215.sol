['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '/*\n', ' * Manager that stores permitted addresses \n', ' */\n', 'contract PermissionManager is Ownable {\n', '    mapping (address => bool) permittedAddresses;\n', '\n', '    function addAddress(address newAddress) public onlyOwner {\n', '        permittedAddresses[newAddress] = true;\n', '    }\n', '\n', '    function removeAddress(address remAddress) public onlyOwner {\n', '        permittedAddresses[remAddress] = false;\n', '    }\n', '\n', '    function isPermitted(address pAddress) public view returns(bool) {\n', '        if (permittedAddresses[pAddress]) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '}\n', '\n', 'contract Registry is Ownable {\n', '\n', '  struct ContributorData {\n', '    bool isActive;\n', '    uint contributionETH;\n', '    uint contributionUSD;\n', '    uint tokensIssued;\n', '    uint quoteUSD;\n', '    uint contributionRNTB;\n', '  }\n', '  mapping(address => ContributorData) public contributorList;\n', '  mapping(uint => address) private contributorIndexes;\n', '\n', '  uint private nextContributorIndex;\n', '\n', '  /* Permission manager contract */\n', '  PermissionManager public permissionManager;\n', '\n', '  bool public completed;\n', '\n', '  modifier onlyPermitted() {\n', '    require(permissionManager.isPermitted(msg.sender));\n', '    _;\n', '  }\n', '\n', '  event ContributionAdded(address _contributor, uint overallEth, uint overallUSD, uint overallToken, uint quote);\n', '  event ContributionEdited(address _contributor, uint overallEth, uint overallUSD,  uint overallToken, uint quote);\n', '  function Registry(address pManager) public {\n', '    permissionManager = PermissionManager(pManager); \n', '    completed = false;\n', '  }\n', '\n', '  function setPermissionManager(address _permadr) public onlyOwner {\n', '    require(_permadr != 0x0);\n', '    permissionManager = PermissionManager(_permadr);\n', '  }\n', '\n', '  function isActiveContributor(address contributor) public view returns(bool) {\n', '    return contributorList[contributor].isActive;\n', '  }\n', '\n', '  function removeContribution(address contributor) public onlyPermitted {\n', '    contributorList[contributor].isActive = false;\n', '  }\n', '\n', '  function setCompleted(bool compl) public onlyPermitted {\n', '    completed = compl;\n', '  }\n', '\n', '  function addContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote ) public onlyPermitted {\n', '    \n', '    if (contributorList[_contributor].isActive == false) {\n', '        contributorList[_contributor].isActive = true;\n', '        contributorList[_contributor].contributionETH = _amount;\n', '        contributorList[_contributor].contributionUSD = _amusd;\n', '        contributorList[_contributor].tokensIssued = _tokens;\n', '        contributorList[_contributor].quoteUSD = _quote;\n', '\n', '        contributorIndexes[nextContributorIndex] = _contributor;\n', '        nextContributorIndex++;\n', '    } else {\n', '      contributorList[_contributor].contributionETH += _amount;\n', '      contributorList[_contributor].contributionUSD += _amusd;\n', '      contributorList[_contributor].tokensIssued += _tokens;\n', '      contributorList[_contributor].quoteUSD = _quote;\n', '    }\n', '    ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);\n', '  }\n', '\n', '  function editContribution(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {\n', '    if (contributorList[_contributor].isActive == true) {\n', '        contributorList[_contributor].contributionETH = _amount;\n', '        contributorList[_contributor].contributionUSD = _amusd;\n', '        contributorList[_contributor].tokensIssued = _tokens;\n', '        contributorList[_contributor].quoteUSD = _quote;\n', '    }\n', '     ContributionEdited(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);\n', '  }\n', '\n', '  function addContributor(address _contributor, uint _amount, uint _amusd, uint _tokens, uint _quote) public onlyPermitted {\n', '    contributorList[_contributor].isActive = true;\n', '    contributorList[_contributor].contributionETH = _amount;\n', '    contributorList[_contributor].contributionUSD = _amusd;\n', '    contributorList[_contributor].tokensIssued = _tokens;\n', '    contributorList[_contributor].quoteUSD = _quote;\n', '    contributorIndexes[nextContributorIndex] = _contributor;\n', '    nextContributorIndex++;\n', '    ContributionAdded(_contributor, contributorList[_contributor].contributionETH, contributorList[_contributor].contributionUSD, contributorList[_contributor].tokensIssued, contributorList[_contributor].quoteUSD);\n', ' \n', '  }\n', '\n', '  function getContributionETH(address _contributor) public view returns (uint) {\n', '      return contributorList[_contributor].contributionETH;\n', '  }\n', '\n', '  function getContributionUSD(address _contributor) public view returns (uint) {\n', '      return contributorList[_contributor].contributionUSD;\n', '  }\n', '\n', '  function getContributionRNTB(address _contributor) public view returns (uint) {\n', '      return contributorList[_contributor].contributionRNTB;\n', '  }\n', '\n', '  function getContributionTokens(address _contributor) public view returns (uint) {\n', '      return contributorList[_contributor].tokensIssued;\n', '  }\n', '\n', '  function addRNTBContribution(address _contributor, uint _amount) public onlyPermitted {\n', '    if (contributorList[_contributor].isActive == false) {\n', '        contributorList[_contributor].isActive = true;\n', '        contributorList[_contributor].contributionRNTB = _amount;\n', '        contributorIndexes[nextContributorIndex] = _contributor;\n', '        nextContributorIndex++;\n', '    } else {\n', '      contributorList[_contributor].contributionETH += _amount;\n', '    }\n', '  }\n', '\n', '  function getContributorByIndex(uint index) public view  returns (address) {\n', '      return contributorIndexes[index];\n', '  }\n', '\n', '  function getContributorAmount() public view returns(uint) {\n', '      return nextContributorIndex;\n', '  }\n', '\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Contract that will work with ERC223 tokens.\n', ' */\n', ' \n', 'contract ERC223ReceivingContract {\n', '\n', '  struct TKN {\n', '    address sender;\n', '    uint value;\n', '    bytes data;\n', '    bytes4 sig;\n', '  }\n', '\n', '  /**\n', '   * @dev Standard ERC223 function that will handle incoming token transfers.\n', '   *\n', '   * @param _from  Token sender address.\n', '   * @param _value Amount of tokens.\n', '   * @param _data  Transaction metadata.\n', '   */\n', '  function tokenFallback(address _from, uint _value, bytes _data) public pure {\n', '    TKN memory tkn;\n', '    tkn.sender = _from;\n', '    tkn.value = _value;\n', '    tkn.data = _data;\n', '    if(_data.length > 0) {\n', '      uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);\n', '      tkn.sig = bytes4(u);\n', '    }\n', '\n', '    /* tkn variable is analogue of msg variable of Ether transaction\n', '    *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)\n', '    *  tkn.value the number of tokens that were sent   (analogue of msg.value)\n', '    *  tkn.data is data of token transaction   (analogue of msg.data)\n', '    *  tkn.sig is 4 bytes signature of function\n', '    *  if data of token transaction is a function execution\n', '    */\n', '  }\n', '\n', '}\n', '\n', 'contract ERC223Interface {\n', '  uint public totalSupply;\n', '  function balanceOf(address who) public view returns (uint);\n', '  function allowedAddressesOf(address who) public view returns (bool);\n', '  function getTotalSupply() public view returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data) public returns (bool ok);\n', '  function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value, bytes data);\n', '  event TransferContract(address indexed from, address indexed to, uint value, bytes data);\n', '}\n', '\n', '/**\n', ' * @title Unity Token is ERC223 token.\n', ' * @author Vladimir Kovalchuk\n', ' */\n', '\n', 'contract UnityToken is ERC223Interface {\n', '  using SafeMath for uint;\n', '\n', '  string public constant name = "Unity Token";\n', '  string public constant symbol = "UNT";\n', '  uint8 public constant decimals = 18;\n', '\n', '\n', '  /* The supply is initially 100UNT to the precision of 18 decimals */\n', '  uint public constant INITIAL_SUPPLY = 100000 * (10 ** uint(decimals));\n', '\n', '  mapping(address => uint) balances; // List of user balances.\n', '  mapping(address => bool) allowedAddresses;\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function addAllowed(address newAddress) public onlyOwner {\n', '    allowedAddresses[newAddress] = true;\n', '  }\n', '\n', '  function removeAllowed(address remAddress) public onlyOwner {\n', '    allowedAddresses[remAddress] = false;\n', '  }\n', '\n', '\n', '  address public owner;\n', '\n', '  /* Constructor initializes the owner&#39;s balance and the supply  */\n', '  function UnityToken() public {\n', '    owner = msg.sender;\n', '    totalSupply = INITIAL_SUPPLY;\n', '    balances[owner] = INITIAL_SUPPLY;\n', '  }\n', '\n', '  function getTotalSupply() public view returns (uint) {\n', '    return totalSupply;\n', '  }\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {\n', '    if (isContract(_to)) {\n', '      require(allowedAddresses[_to]);\n', '      if (balanceOf(msg.sender) < _value)\n', '        revert();\n', '\n', '      balances[msg.sender] = balances[msg.sender].sub(_value);\n', '      balances[_to] = balances[_to].add(_value);\n', '      assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));\n', '      TransferContract(msg.sender, _to, _value, _data);\n', '      return true;\n', '    }\n', '    else {\n', '      return transferToAddress(_to, _value, _data);\n', '    }\n', '  }\n', '\n', '\n', '  // Function that is called when a user or another contract wants to transfer funds .\n', '  function transfer(address _to, uint _value, bytes _data) public returns (bool success) {\n', '\n', '    if (isContract(_to)) {\n', '      return transferToContract(_to, _value, _data);\n', '    } else {\n', '      return transferToAddress(_to, _value, _data);\n', '    }\n', '  }\n', '\n', '  // Standard function transfer similar to ERC20 transfer with no _data .\n', '  // Added due to backwards compatibility reasons .\n', '  function transfer(address _to, uint _value) public returns (bool success) {\n', '    //standard function transfer similar to ERC20 transfer with no _data\n', '    //added due to backwards compatibility reasons\n', '    bytes memory empty;\n', '    if (isContract(_to)) {\n', '      return transferToContract(_to, _value, empty);\n', '    }\n', '    else {\n', '      return transferToAddress(_to, _value, empty);\n', '    }\n', '  }\n', '\n', '  //assemble the given address bytecode. If bytecode exists then the _addr is a contract.\n', '  function isContract(address _addr) private view returns (bool is_contract) {\n', '    uint length;\n', '    assembly {\n', '    //retrieve the size of the code on target address, this needs assembly\n', '      length := extcodesize(_addr)\n', '    }\n', '    return (length > 0);\n', '  }\n', '\n', '  //function that is called when transaction target is an address\n', '  function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    if (balanceOf(msg.sender) < _value)\n', '      revert();\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '  //function that is called when transaction target is a contract\n', '  function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {\n', '    require(allowedAddresses[_to]);\n', '    if (balanceOf(msg.sender) < _value)\n', '      revert();\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);\n', '    receiver.tokenFallback(msg.sender, _value, _data);\n', '    TransferContract(msg.sender, _to, _value, _data);\n', '    return true;\n', '  }\n', '\n', '\n', '  function balanceOf(address _owner) public view returns (uint balance) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function allowedAddressesOf(address _owner) public view returns (bool allowed) {\n', '    return allowedAddresses[_owner];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Hold  contract.\n', ' * @author Vladimir Kovalchuk\n', ' */\n', 'contract Hold is Ownable {\n', '\n', '    uint8 stages = 5;\n', '    uint8 public percentage;\n', '    uint8 public currentStage;\n', '    uint public initialBalance;\n', '    uint public withdrawed;\n', '    \n', '    address public multisig;\n', '    Registry registry;\n', '\n', '    PermissionManager public permissionManager;\n', '    uint nextContributorToTransferEth;\n', '    address public observer;\n', '    uint dateDeployed;\n', '    mapping(address => bool) private hasWithdrawedEth;\n', '\n', '    event InitialBalanceChanged(uint balance);\n', '    event EthReleased(uint ethreleased);\n', '    event EthRefunded(address contributor, uint ethrefunded);\n', '    event StageChanged(uint8 newStage);\n', '    event EthReturnedToOwner(address owner, uint balance);\n', '\n', '    modifier onlyPermitted() {\n', '        require(permissionManager.isPermitted(msg.sender) || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyObserver() {\n', '        require(msg.sender == observer || msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function Hold(address _multisig, uint cap, address pm, address registryAddress, address observerAddr) public {\n', '        percentage = 100 / stages;\n', '        currentStage = 0;\n', '        multisig = _multisig;\n', '        initialBalance = cap;\n', '        dateDeployed = now;\n', '        permissionManager = PermissionManager(pm);\n', '        registry = Registry(registryAddress);\n', '        observer = observerAddr;\n', '    }\n', '\n', '    function setPermissionManager(address _permadr) public onlyOwner {\n', '        require(_permadr != 0x0);\n', '        permissionManager = PermissionManager(_permadr);\n', '    }\n', '\n', '    function setObserver(address observerAddr) public onlyOwner {\n', '        require(observerAddr != 0x0);\n', '        observer = observerAddr;\n', '    }\n', '\n', '    function setInitialBalance(uint inBal) public {\n', '        initialBalance = inBal;\n', '        InitialBalanceChanged(inBal);\n', '    }\n', '\n', '    function releaseAllETH() onlyPermitted public {\n', '        uint balReleased = getBalanceReleased();\n', '        require(balReleased > 0);\n', '        require(this.balance >= balReleased);\n', '        multisig.transfer(balReleased);\n', '        withdrawed += balReleased;\n', '        EthReleased(balReleased);\n', '    }\n', '\n', '    function releaseETH(uint n) onlyPermitted public {\n', '        require(this.balance >= n);\n', '        require(getBalanceReleased() >= n);\n', '        multisig.transfer(n);\n', '        withdrawed += n;\n', '        EthReleased(n);\n', '    } \n', '\n', '    function getBalance() public view returns (uint) {\n', '        return this.balance;\n', '    }\n', '\n', '    function changeStageAndReleaseETH() public onlyObserver {\n', '        uint8 newStage = currentStage + 1;\n', '        require(newStage <= stages);\n', '        currentStage = newStage;\n', '        StageChanged(newStage);\n', '        releaseAllETH();\n', '    }\n', '\n', '    function changeStage() public onlyObserver {\n', '        uint8 newStage = currentStage + 1;\n', '        require(newStage <= stages);\n', '        currentStage = newStage;\n', '        StageChanged(newStage);\n', '    }\n', '\n', '    function getBalanceReleased() public view returns (uint) {\n', '        return initialBalance * percentage * currentStage / 100 - withdrawed ;\n', '    }\n', '\n', '    function returnETHByOwner() public onlyOwner {\n', '        require(now > dateDeployed + 183 days);\n', '        uint balance = getBalance();\n', '        owner.transfer(getBalance());\n', '        EthReturnedToOwner(owner, balance);\n', '    }\n', '\n', '    function refund(uint _numberOfReturns) public onlyOwner {\n', '        require(_numberOfReturns > 0);\n', '        address currentParticipantAddress;\n', '\n', '        for (uint cnt = 0; cnt < _numberOfReturns; cnt++) {\n', '            currentParticipantAddress = registry.getContributorByIndex(nextContributorToTransferEth);\n', '            if (currentParticipantAddress == 0x0) \n', '                return;\n', '\n', '            if (!hasWithdrawedEth[currentParticipantAddress]) {\n', '                uint EthAmount = registry.getContributionETH(currentParticipantAddress);\n', '                EthAmount -=  EthAmount * (percentage / 100 * currentStage);\n', '\n', '                currentParticipantAddress.transfer(EthAmount);\n', '                EthRefunded(currentParticipantAddress, EthAmount);\n', '                hasWithdrawedEth[currentParticipantAddress] = true;\n', '            }\n', '            nextContributorToTransferEth += 1;\n', '        }\n', '        \n', '    }  \n', '\n', '    function() public payable {\n', '\n', '    }\n', '\n', '  function getWithdrawed(address contrib) public onlyPermitted view returns (bool) {\n', '    return hasWithdrawedEth[contrib];\n', '  }\n', '}']