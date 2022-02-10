['pragma solidity ^0.4.13;\n', '\n', 'contract AbstractENS{\n', '\n', '    function owner(bytes32 node) constant returns(address);\n', '    function resolver(bytes32 node) constant returns(address);\n', '    function ttl(bytes32 node) constant returns(uint64);\n', '    function setOwner(bytes32 node, address owner);\n', '    function setSubnodeOwner(bytes32 node, bytes32 label, address owner);\n', '    function setResolver(bytes32 node, address resolver);\n', '    function setTTL(bytes32 node, uint64 ttl);\n', '\n', '    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);\n', '    event Transfer(bytes32 indexed node, address owner);\n', '    event NewResolver(bytes32 indexed node, address resolver);\n', '    event NewTTL(bytes32 indexed node, uint64 ttl);\n', '}\n', '\n', 'contract subSale{\n', '\n', '  AbstractENS ens = AbstractENS(0x314159265dD8dbb310642f98f50C066173C1259b);\n', '  address admin = 0x8301Fb8945760Fa2B3C669e8F420B8795Dc03766;\n', '\n', '  struct Domain{\n', '    address originalOwner;\n', '    uint regPeriod;\n', '    bool subSale;\n', '    uint subPrice;\n', '    uint subExpiry;\n', '  }\n', '\n', '  mapping(bytes32=>Domain) records;\n', '\n', '  modifier node_owner(bytes32 node){\n', '    if (ens.owner(node) != msg.sender) throw;\n', '    _;\n', '  }\n', '\n', '  modifier recorded_owner(bytes32 node){\n', '    if (records[node].originalOwner != msg.sender) throw;\n', '    _;\n', '  }\n', '\n', '  function subSale() {}\n', '\n', '  function listSubName(bytes32 node,uint price,uint expiry) node_owner(node){\n', '    require(records[node].subSale != true);\n', ' \n', '    records[node].originalOwner=msg.sender;\n', '    records[node].subSale=true;\n', '    records[node].subPrice=price;\n', '    records[node].subExpiry=expiry;\n', '  }\n', '\n', '  function unlistSubName(bytes32 node) recorded_owner(node){\n', '    require(records[node].subSale==true);\n', '\n', '    ens.setOwner(node,records[node].originalOwner);\n', '\n', '    records[node].originalOwner=address(0x0);\n', '    records[node].subSale=false;\n', '    records[node].subPrice = 0;\n', '    records[node].subExpiry = 0;\n', '  }\n', '\n', '  function nodeCheck(bytes32 node) returns(address){\n', '    return ens.owner(node);\n', '  }\n', '\n', '  function subRegistrationPeriod(bytes32 node) returns(uint){\n', '    return records[node].subExpiry;\n', '  }\n', '\n', '  function checkSubAvailability(bytes32 node) returns(bool){\n', '    return records[node].subSale;\n', '  }\n', '\n', '  function checkSubPrice(bytes32 node) returns(uint){\n', '    return records[node].subPrice;\n', '  }\n', '\n', '  function subBuy(bytes32 rootNode,bytes32 subNode,address newOwner) payable {\n', '    require(records[rootNode].subSale == true);\n', '    require(msg.value >= records[rootNode].subPrice);\n', '\n', '    var newNode = sha3(rootNode,subNode);\n', '    require(records[newNode].regPeriod < now);\n', '\n', '    uint fee = msg.value/20;\n', '    uint netPrice = msg.value - fee;\n', '\n', '    admin.transfer(fee);\n', '    records[rootNode].originalOwner.transfer(netPrice);\n', '\n', '    records[newNode].regPeriod = now + records[rootNode].subExpiry;\n', '    records[newNode].subSale = false;\n', '    records[newNode].subPrice = 0;\n', '    records[newNode].subExpiry = 0;\n', '\n', '    ens.setSubnodeOwner(rootNode,subNode,newOwner);\n', '  }\n', '\n', ' function() payable{\n', '    admin.transfer(msg.value);\n', '  }\n', '\n', '}']