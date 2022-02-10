['pragma solidity ^0.4.11;\n', '\n', 'contract Factory {\n', '  address developer = 0x007C67F0CDBea74592240d492Aef2a712DAFa094c3;\n', '  \n', '  event ContractCreated(address creator, address newcontract, uint timestamp, string contract_type);\n', '    \n', '  function setDeveloper(address _dev) {\n', '    if(developer==address(0) || developer==msg.sender){\n', '       developer = _dev;\n', '    }\n', '  }\n', '  \n', '  function createContract (bool isbroker, string contract_type) {\n', '    address newContract = new Broker(isbroker, developer, msg.sender);\n', '    ContractCreated(msg.sender, newContract, block.timestamp, contract_type);\n', '  } \n', '}\n', '\n', 'contract Broker {\n', '  enum State { Created, Validated, Locked, Finished }\n', '  State public state;\n', '\n', '  enum FileState { \n', '    Created, \n', '    Invalidated\n', '    // , Confirmed \n', '  }\n', '\n', '  struct File{\n', '    // The purpose of this file. Like, picture, license info., etc.\n', '    // to save the space, we better use short name.\n', '    // Dapps should match proper long name for this.\n', '    bytes32 purpose;\n', '    // name of the file\n', '    string name;\n', '    // ipfs id for this file\n', '    string ipfshash;\n', '    FileState state;\n', '  }\n', '\n', '  struct Item{\n', '    string name;\n', '    // At least 0.1 Finney, because it&#39;s the fee to the developer\n', '    uint   price;\n', '    // this could be a link to an Web page explaining about this item\n', '    string detail;\n', '    File[] documents;\n', '  }\n', '\n', '  Item public item;\n', '  address public seller;\n', '  address public buyer;\n', '  address public broker;\n', '  uint    public brokerFee;\n', '  // Minimum 0.1 Finney (0.0001 eth ~ 25Cent) to 0.01% of the price.\n', '  uint    public developerfee = 0.1 finney;\n', '  uint    minimumdeveloperfee = 0.1 finney;\n', '  address developer = 0x007C67F0CDBea74592240d492Aef2a712DAFa094c3;\n', '  // bool public validated;\n', '  address creator = 0x0;\n', '  address factory = 0x0;\n', '\n', '\n', '  modifier onlyBuyer() {\n', '    require(msg.sender == buyer);\n', '    _;\n', '  }\n', '\n', '  modifier onlySeller() {\n', '    require(msg.sender == seller);\n', '    _;\n', '  }\n', '\n', '  modifier onlyCreator() {\n', '    require(msg.sender == creator);\n', '    _;\n', '  }\n', '\n', '  modifier onlyBroker() {\n', '    require(msg.sender == broker);\n', '    _;\n', '  }\n', '\n', '  modifier inState(State _state) {\n', '      require(state == _state);\n', '      _;\n', '  }\n', '\n', '  modifier condition(bool _condition) {\n', '      require(_condition);\n', '      _;\n', '  }\n', '\n', '  event AbortedBySeller();\n', '  event AbortedByBroker();\n', '  event PurchaseConfirmed();\n', '  event ItemReceived();\n', '  event Validated();\n', '  event ItemInfoChanged(string name, uint price, string detail, uint developerfee);\n', '  event SellerChanged(address seller);\n', '  event BrokerChanged(address broker);\n', '  event BrokerFeeChanged(uint fee);\n', '\n', '  // The constructor\n', '  function Broker(bool isbroker, address _dev, address _creator) {\n', '    if(creator==address(0)){\n', '      //storedData = initialValue;\n', '      if(isbroker)\n', '        broker = _creator;\n', '      else\n', '        seller = _creator;\n', '      creator = _creator;\n', '      // value = msg.value / 2;\n', '      // require((2 * value) == msg.value);\n', '      state = State.Created;\n', '\n', '      // validated = false;\n', '      brokerFee = 50;\n', '    }\n', '    if(developer==address(0) || developer==msg.sender){\n', '       developer = _dev;\n', '    }\n', '    if(factory==address(0)){\n', '       factory = msg.sender;\n', '    }\n', '  }\n', '\n', '  function joinAsBuyer(){\n', '    if(buyer==address(0)){\n', '      buyer = msg.sender;\n', '    }\n', '  }\n', '\n', '  function joinAsBroker(){\n', '    if(broker==address(0)){\n', '      broker = msg.sender;\n', '    }\n', '  }\n', '\n', '  function createOrSet(string name, uint price, string detail)\n', '    inState(State.Created)\n', '    onlyCreator\n', '  {\n', '    require(price > minimumdeveloperfee);\n', '    item.name = name;\n', '    item.price = price;\n', '    item.detail = detail;\n', '    developerfee = (price/1000)<minimumdeveloperfee ? minimumdeveloperfee : (price/1000);\n', '    ItemInfoChanged(name, price, detail, developerfee);\n', '  }\n', '\n', '  function getBroker()\n', '    constant returns(address, uint)\n', '  {\n', '    return (broker, brokerFee);\n', '  }\n', '\n', '  function getSeller()\n', '    constant returns(address)\n', '  {\n', '    return (seller);\n', '  }\n', '\n', '  function setBroker(address _address)\n', '    onlySeller\n', '    inState(State.Created)\n', '  {\n', '    broker = _address;\n', '    BrokerChanged(broker);\n', '  }\n', '\n', '  function setBrokerFee(uint fee)\n', '    onlyCreator\n', '    inState(State.Created)\n', '  {\n', '    brokerFee = fee;\n', '    BrokerFeeChanged(fee);\n', '  }\n', '\n', '  function setSeller(address _address)\n', '    onlyBroker\n', '    inState(State.Created)\n', '  {\n', '    seller = _address;\n', '    SellerChanged(seller);\n', '  }\n', '\n', '  // We will have some &#39;peculiar&#39; list of documents\n', '  // for each deals. \n', '  // For ex, for House we will require\n', '  // proof of documents about the basic information of the House,\n', '  // and some insurance information.\n', '  // So we can make a template for each differene kind of deals.\n', '  // Deals for a house, deals for a Car, etc.\n', '  function addDocument(bytes32 _purpose, string _name, string _ipfshash)\n', '  {\n', '    require(state != State.Finished);\n', '    require(state != State.Locked);\n', '    item.documents.push( File({\n', '      purpose:_purpose, name:_name, ipfshash:_ipfshash, state:FileState.Created}\n', '      ) \n', '    );\n', '  }\n', '\n', '  // deleting actual file on the IPFS network is very hard.\n', '  function deleteDocument(uint index)\n', '  {\n', '    require(state != State.Finished);\n', '    require(state != State.Locked);\n', '    if(index<item.documents.length){\n', '      item.documents[index].state = FileState.Invalidated;\n', '    }\n', '  }\n', '\n', '  function validate()\n', '    onlyBroker\n', '    inState(State.Created)\n', '  {\n', '    // if(index<item.documents.length){\n', '    //   item.documents[index].state = FileState.Confirmed;\n', '    // }\n', '    Validated();\n', '    // validated = true;\n', '    state = State.Validated;\n', '  }\n', '\n', '  /// Abort the purchase and reclaim the ether.\n', '  /// Can only be called by the seller before\n', '  /// the contract is locked.\n', '  function abort()\n', '      onlySeller\n', '      inState(State.Created)\n', '  {\n', '      AbortedBySeller();\n', '      state = State.Finished;\n', '      // validated = false;\n', '      seller.transfer(this.balance);\n', '  }\n', '\n', '  function abortByBroker()\n', '      onlyBroker\n', '  {\n', '      require(state != State.Finished);\n', '      state = State.Finished;\n', '      AbortedByBroker();\n', '      buyer.transfer(this.balance);\n', '  }\n', '\n', '  /// Confirm the purchase as buyer.\n', '  /// The ether will be locked until confirmReceived\n', '  /// is called.\n', '  function confirmPurchase()\n', '      inState(State.Validated)\n', '      condition(msg.value == item.price)\n', '      payable\n', '  {\n', '      state = State.Locked;\n', '      buyer = msg.sender;\n', '      PurchaseConfirmed();\n', '  }\n', '\n', '  /// Confirm that you (the buyer) received the item.\n', '  /// This will release the locked ether.\n', '  function confirmReceived()\n', '      onlyBroker\n', '      inState(State.Locked)\n', '  {\n', '      // It is important to change the state first because\n', '      // otherwise, the contracts called using `send` below\n', '      // can call in again here.\n', '      state = State.Finished;\n', '\n', '      // NOTE: This actually allows both the buyer and the seller to\n', '      // block the refund - the withdraw pattern should be used.\n', '      seller.transfer(this.balance-brokerFee-developerfee);\n', '      broker.transfer(brokerFee);\n', '      developer.transfer(developerfee);\n', '\n', '      ItemReceived();\n', '  }\n', '\n', '  function getInfo() constant returns (State, string, uint, string, uint, uint){\n', '    return (state, item.name, item.price, item.detail, item.documents.length, developerfee);\n', '  }\n', '\n', '  function getFileAt(uint index) constant returns(uint, bytes32, string, string, FileState){\n', '    return (index,\n', '      item.documents[index].purpose,\n', '      item.documents[index].name,\n', '      item.documents[index].ipfshash,\n', '      item.documents[index].state);\n', '  }\n', '}']