['pragma solidity ^0.4.18;\n', '\n', '// File: contracts/ERC20.sol\n', '\n', '/*\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 {\n', '  uint public totalSupply;\n', '\n', '  function balanceOf(address who) public constant returns (uint);\n', '\n', '  function allowance(address owner, address spender) public constant returns (uint);\n', '\n', '  function transfer(address to, uint value) public returns (bool ok);\n', '\n', '  function transferFrom(address from, address to, uint value) public returns (bool ok);\n', '\n', '  function approve(address spender, uint value) public returns (bool ok);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '  event Approval(address indexed owner, address indexed spender, uint value);\n', '}\n', '\n', '// ERC223\n', 'contract ContractReceiver {\n', '  function tokenFallback(address from, uint value) public;\n', '}\n', '\n', '// File: contracts/Ownable.sol\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', 'contract Ownable {\n', '\n', '  address public owner;\n', '\n', '  function Ownable() public { owner = msg.sender; }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '\n', '  }\n', '}\n', '\n', '// File: contracts/Deployer.sol\n', '\n', 'contract Deployer {\n', '\n', '  address public deployer;\n', '\n', '  function Deployer() public { deployer = msg.sender; }\n', '\n', '  modifier onlyDeployer() {\n', '    require(msg.sender == deployer);\n', '    _;\n', '  }\n', '}\n', '\n', '// File: contracts/OracleOwnable.sol\n', '\n', 'contract OracleOwnable is Ownable {\n', '\n', '  address public oracle;\n', '\n', '  modifier onlyOracle() {\n', '    require(msg.sender == oracle);\n', '    _;\n', '  }\n', '\n', '  modifier onlyOracleOrOwner() {\n', '    require(msg.sender == oracle || msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function setOracle(address newOracle) public onlyOracleOrOwner {\n', '    if (newOracle != address(0)) {\n', '      oracle = newOracle;\n', '    }\n', '\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ModultradeLibrary.sol\n', '\n', 'library ModultradeLibrary {\n', '  enum Currencies {\n', '  ETH, MTR\n', '  }\n', '\n', '  enum ProposalStates {\n', '  Created, Paid, Delivery, Closed, Canceled\n', '  }\n', '}\n', '\n', '// File: contracts/ModultradeStorage.sol\n', '\n', 'contract ModultradeStorage is Ownable, Deployer {\n', '\n', '  bool private _doMigrate = true;\n', '\n', '  mapping (address => address[]) public sellerProposals;\n', '\n', '  mapping (uint => address) public proposalListAddress;\n', '\n', '  address[] public proposals;\n', '\n', '  event InsertProposalEvent (address _proposal, uint _id, address _seller);\n', '\n', '  event PaidProposalEvent (address _proposal, uint _id);\n', '\n', '  function ModultradeStorage() public {}\n', '\n', '  function insertProposal(address seller, uint id, address proposal) public onlyOwner {\n', '    sellerProposals[seller].push(proposal);\n', '    proposalListAddress[id] = proposal;\n', '    proposals.push(proposal);\n', '\n', '    InsertProposalEvent(proposal, id, seller);\n', '  }\n', '\n', '  function getProposalsBySeller(address seller) public constant returns (address[]){\n', '    return sellerProposals[seller];\n', '  }\n', '\n', '  function getProposals() public constant returns (address[]){\n', '    return proposals;\n', '  }\n', '\n', '  function getProposalById(uint id) public constant returns (address){\n', '    return proposalListAddress[id];\n', '  }\n', '\n', '  function getCount() public constant returns (uint) {\n', '    return proposals.length;\n', '  }\n', '\n', '  function getCountBySeller(address seller) public constant returns (uint) {\n', '    return sellerProposals[seller].length;\n', '  }\n', '\n', '  function firePaidProposalEvent(address proposal, uint id) public {\n', '    require(proposalListAddress[id] == proposal);\n', '\n', '    PaidProposalEvent(proposal, id);\n', '  }\n', '\n', '  function changeOwner(address newOwner) public onlyDeployer {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/ModultradeProposal.sol\n', '\n', 'contract ModultradeProposal is OracleOwnable, ContractReceiver {\n', '\n', '  address public seller;\n', '\n', '  address public buyer;\n', '\n', '  uint public id;\n', '\n', '  string public title;\n', '\n', '  uint public price;\n', '\n', '  ModultradeLibrary.Currencies public currency;\n', '\n', '  uint public units;\n', '\n', '  uint public total;\n', '\n', '  uint public validUntil;\n', '\n', '  ModultradeLibrary.ProposalStates public state;\n', '\n', '  uint public payDate;\n', '\n', '  string public deliveryId;\n', '\n', '  uint public fee;\n', '\n', '  address public feeAddress;\n', '\n', '  ERC20 mtrContract;\n', '\n', '  Modultrade modultrade;\n', '\n', '  bytes public tokenFallbackData;\n', '\n', '  event CreatedEvent(uint _id, ModultradeLibrary.ProposalStates _state);\n', '\n', '  event PaidEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _buyer);\n', '\n', '  event DeliveryEvent(uint _id, ModultradeLibrary.ProposalStates _state, string _deliveryId);\n', '\n', '  event ClosedEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _seller, uint _amount);\n', '\n', '  event CanceledEvent(uint _id, ModultradeLibrary.ProposalStates _state, address _buyer, uint _amount);\n', '\n', '  function ModultradeProposal(address _modultrade, address _seller, address _mtrContractAddress) public {\n', '    seller = _seller;\n', '    state = ModultradeLibrary.ProposalStates.Created;\n', '    mtrContract = ERC20(_mtrContractAddress);\n', '    modultrade = Modultrade(_modultrade);\n', '  }\n', '\n', '  function setProposal(uint _id,\n', '  string _title,\n', '  uint _price,\n', '  ModultradeLibrary.Currencies _currency,\n', '  uint _units,\n', '  uint _total,\n', '  uint _validUntil\n', '  ) public onlyOracleOrOwner {\n', '    require(state == ModultradeLibrary.ProposalStates.Created);\n', '    id = _id;\n', '    title = _title;\n', '    price = _price;\n', '    currency = _currency;\n', '    units = _units;\n', '    total = _total;\n', '    validUntil = _validUntil;\n', '  }\n', '\n', '  function setFee(uint _fee, address _feeAddress) public onlyOracleOrOwner {\n', '    require(state == ModultradeLibrary.ProposalStates.Created);\n', '    fee = _fee;\n', '    feeAddress = _feeAddress;\n', '  }\n', '\n', '  function() public payable {purchase();}\n', '\n', '  function purchase() public payable {\n', '    require(currency == ModultradeLibrary.Currencies.ETH);\n', '    require(msg.value >= total);\n', '    setPaid(msg.sender);\n', '  }\n', '\n', '  function setPaid(address _buyer) internal {\n', '    require(state == ModultradeLibrary.ProposalStates.Created);\n', '    state = ModultradeLibrary.ProposalStates.Paid;\n', '    buyer = _buyer;\n', '    payDate = now;\n', '    PaidEvent(id, state, buyer);\n', '    modultrade.firePaidProposalEvent(address(this), id);\n', '  }\n', '\n', '  function paid(address _buyer) public onlyOracleOrOwner {\n', '    require(getBalance() >= total);\n', '    setPaid(_buyer);\n', '  }\n', '\n', '  function mtrTokenFallBack(address from, uint value) internal {\n', '    require(currency == ModultradeLibrary.Currencies.MTR);\n', '    require(msg.sender == address(mtrContract));\n', '    require(value >= total);\n', '    setPaid(from);\n', '  }\n', '\n', '  function tokenFallback(address from, uint value) public {\n', '    mtrTokenFallBack(from, value);\n', '  }\n', '\n', '  function tokenFallback(address from, uint value, bytes data) public {\n', '    tokenFallbackData = data;\n', '    mtrTokenFallBack(from, value);\n', '  }\n', '\n', '  function delivery(string _deliveryId) public onlyOracleOrOwner {\n', '    require(state == ModultradeLibrary.ProposalStates.Paid);\n', '    deliveryId = _deliveryId;\n', '    state = ModultradeLibrary.ProposalStates.Delivery;\n', '    DeliveryEvent(id, state, deliveryId);\n', '    modultrade.fireDeliveryProposalEvent(address(this), id);\n', '  }\n', '\n', '  function close() public onlyOracleOrOwner {\n', '    require(state != ModultradeLibrary.ProposalStates.Closed);\n', '    require(state != ModultradeLibrary.ProposalStates.Canceled);\n', '\n', '    if (currency == ModultradeLibrary.Currencies.ETH) {\n', '      closeEth();\n', '    }\n', '    if (currency == ModultradeLibrary.Currencies.MTR) {\n', '      closeMtr();\n', '    }\n', '\n', '    state = ModultradeLibrary.ProposalStates.Closed;\n', '    ClosedEvent(id, state, seller, this.balance);\n', '    modultrade.fireCloseProposalEvent(address(this), id);\n', '  }\n', '\n', '  function closeEth() private {\n', '    if (fee > 0) {\n', '      feeAddress.transfer(fee);\n', '    }\n', '    seller.transfer(this.balance);\n', '  }\n', '\n', '  function closeMtr() private {\n', '    if (fee > 0) {\n', '      mtrContract.transfer(feeAddress, fee);\n', '    }\n', '    mtrContract.transfer(seller, getBalance());\n', '  }\n', '\n', '  function cancel(uint cancelFee) public onlyOracleOrOwner {\n', '    require(state != ModultradeLibrary.ProposalStates.Closed);\n', '    require(state != ModultradeLibrary.ProposalStates.Canceled);\n', '    uint _balance = getBalance();\n', '    if (_balance > 0) {\n', '      if (currency == ModultradeLibrary.Currencies.ETH) {\n', '        cancelEth(cancelFee);\n', '      }\n', '      if (currency == ModultradeLibrary.Currencies.MTR) {\n', '        cancelMtr(cancelFee);\n', '      }\n', '    }\n', '    state = ModultradeLibrary.ProposalStates.Canceled;\n', '    CanceledEvent(id, state, buyer, this.balance);\n', '    modultrade.fireCancelProposalEvent(address(this), id);\n', '  }\n', '\n', '  function cancelEth(uint cancelFee) private {\n', '    uint _fee = cancelFee;\n', '    if (cancelFee > this.balance) {\n', '      _fee = this.balance;\n', '    }\n', '    feeAddress.transfer(_fee);\n', '    if (this.balance > 0 && buyer != address(0)) {\n', '      buyer.transfer(this.balance);\n', '    }\n', '  }\n', '\n', '  function cancelMtr(uint cancelFee) private {\n', '    uint _fee = cancelFee;\n', '    uint _balance = getBalance();\n', '    if (cancelFee > _balance) {\n', '      _fee = _balance;\n', '    }\n', '    mtrContract.transfer(feeAddress, _fee);\n', '    _balance = getBalance();\n', '    if (_balance > 0 && buyer != address(0)) {\n', '      mtrContract.transfer(buyer, _balance);\n', '    }\n', '  }\n', '\n', '  function getBalance() public constant returns (uint) {\n', '    if (currency == ModultradeLibrary.Currencies.MTR) {\n', '      return mtrContract.balanceOf(address(this));\n', '    }\n', '\n', '    return this.balance;\n', '  }\n', '}\n', '\n', '// File: contracts/Modultrade.sol\n', '\n', 'contract Modultrade is OracleOwnable, Deployer {\n', '\n', '  address public mtrContractAddress;\n', '\n', '  ModultradeStorage public modultradeStorage;\n', '\n', '  event ProposalCreatedEvent(uint _id, address _proposal);\n', '\n', '  event PaidProposalEvent (address _proposal, uint _id);\n', '  event CancelProposalEvent (address _proposal, uint _id);\n', '  event CloseProposalEvent (address _proposal, uint _id);\n', '  event DeliveryProposalEvent (address _proposal, uint _id);\n', '\n', '  event LogEvent (address _addr, string _log, uint _i);\n', '\n', '  function Modultrade(address _owner, address _oracle, address _mtrContractAddress, address _storageAddress) public {\n', '    transferOwnership(_owner);\n', '    setOracle(_oracle);\n', '    mtrContractAddress = _mtrContractAddress;\n', '    modultradeStorage = ModultradeStorage(_storageAddress);\n', '  }\n', '\n', '  function createProposal(\n', '  address seller,\n', '  uint id,\n', '  string title,\n', '  uint price,\n', '  ModultradeLibrary.Currencies currency,\n', '  uint units,\n', '  uint total,\n', '  uint validUntil,\n', '  uint fee,\n', '  address feeAddress\n', '  ) public onlyOracleOrOwner {\n', '    ModultradeProposal proposal = new ModultradeProposal(address(this), seller, mtrContractAddress);\n', '    LogEvent (address(proposal), &#39;ModultradeProposal&#39;, 1);\n', '    proposal.setProposal(id, title, price, currency, units, total, validUntil);\n', '    proposal.setFee(fee, feeAddress);\n', '    proposal.setOracle(oracle);\n', '    proposal.transferOwnership(owner);\n', '\n', '    modultradeStorage.insertProposal(seller, id, address(proposal));\n', '    ProposalCreatedEvent(proposal.id(), address(proposal));\n', '  }\n', '\n', '\n', '  function transferStorage(address _owner) public onlyOracleOrOwner {\n', '    modultradeStorage.transferOwnership(_owner);\n', '  }\n', '\n', '  function firePaidProposalEvent(address proposal, uint id) public {\n', '    var _proposal = modultradeStorage.getProposalById(id);\n', '    require(_proposal == proposal);\n', '    PaidProposalEvent(proposal, id);\n', '  }\n', '\n', '  function fireCancelProposalEvent(address proposal, uint id) public {\n', '    var _proposal = modultradeStorage.getProposalById(id);\n', '    require(_proposal == proposal);\n', '    CancelProposalEvent(proposal, id);\n', '  }\n', '\n', '  function fireCloseProposalEvent(address proposal, uint id) public {\n', '    var _proposal = modultradeStorage.getProposalById(id);\n', '    require(_proposal == proposal);\n', '    CloseProposalEvent(proposal, id);\n', '  }\n', '\n', '  function fireDeliveryProposalEvent(address proposal, uint id) public {\n', '    var _proposal = modultradeStorage.getProposalById(id);\n', '    require(_proposal == proposal);\n', '    DeliveryProposalEvent(proposal, id);\n', '  }\n', '\n', '}']