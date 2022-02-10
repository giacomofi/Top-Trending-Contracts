['pragma solidity ^0.4.18;\n', '\n', 'contract Redeem {\n', '\n', '  struct Item {\n', '    address owner;\n', '    uint price;\n', '    uint nextPrice;\n', '    string slogan;\n', '  }\n', '\n', '  address admin;\n', '  uint[] cuts = [50,40,30,30,20];\n', '  uint[] priceUps = [2105,1406,1288,1206,1173];\n', '  uint[] priceMilestones = [20,500,2000,5000];\n', '  uint[] startPrice = [7,7,7,13,13,13,13,13,17,17];\n', '  bool running = true;\n', '\n', '  mapping (uint => Item) items;\n', '  uint[] itemIndices;\n', '  function soldItems() view public returns (uint[]) { return itemIndices; }\n', '\n', '  event OnSold(uint indexed _iItem, address indexed _oldOwner, address indexed _newOwner, uint _oldPrice, uint _newPrice, string _newSlogan);\n', '  \n', '  modifier onlyAdmin() {\n', '    require(msg.sender == admin);\n', '    _;\n', '  }\n', '  modifier enabled() {\n', '    require(running);\n', '    _;\n', '  }\n', '\n', '  function Redeem() public {\n', '    admin = msg.sender;\n', '  }\n', '\n', '  function itemAt(uint _idx) view public returns (uint iItem, address owner, uint price, uint nextPrice, string slogan) {\n', '    Item memory item = items[_idx];\n', '    if (item.price > 0) {\n', '      return (_idx, item.owner, item.price, item.nextPrice, item.slogan);\n', '    } else {\n', '      uint p = startPrice[_idx % startPrice.length];\n', '      return (_idx, item.owner, p, nextPriceOf(p), "");\n', '    }\n', '  }\n', '\n', '  function buy(uint _idx, string _slogan) enabled payable public {\n', '    Item storage item = items[_idx];\n', '    if (item.price == 0) {\n', '      item.price = startPrice[_idx % startPrice.length];\n', '      item.nextPrice = nextPriceOf(item.price);\n', '      itemIndices.push(_idx);\n', '    }\n', '    require(item.price > 0);\n', '    uint curWei = item.price * 1e15;\n', '    require(curWei <= msg.value);\n', '    address oldOwner = item.owner;\n', '    uint oldPrice = item.price;\n', '    if (item.owner != 0x0) {\n', '      require(item.owner != msg.sender);\n', '      item.owner.transfer(curWei * (1000 - cutOf(item.price)) / 1000);\n', '    }\n', '    msg.sender.transfer(msg.value - curWei);\n', '    item.owner = msg.sender;\n', '    item.slogan = _slogan;\n', '    item.price = item.nextPrice;\n', '    item.nextPrice = nextPriceOf(item.price);\n', '    OnSold(_idx, oldOwner, item.owner, oldPrice, item.price, item.slogan);\n', '  }\n', '\n', '  function nextPriceOf(uint _price) view internal returns (uint) {\n', '    for (uint i = 0; i<priceUps.length; ++i) {\n', '      if (i >= priceMilestones.length || _price < priceMilestones[i])\n', '        return _price * priceUps[i] / 1000;\n', '    }\n', '    require(false); //should not happen\n', '    return 0;\n', '  }\n', '  \n', '  function cutOf(uint _price) view internal returns (uint) {\n', '    for (uint i = 0; i<cuts.length; ++i) {\n', '      if (i >= priceMilestones.length || _price < priceMilestones[i])\n', '        return cuts[i];\n', '    }\n', '    require(false); //should not happen\n', '    return 0;\n', '  }\n', '  \n', '  function contractInfo() view public returns (bool, address, uint256, uint[], uint[], uint[], uint[]) {\n', '    return (running, admin, this.balance, startPrice, priceMilestones, cuts, priceUps);\n', '  }\n', '\n', '  function enable(bool b) onlyAdmin public {\n', '    running = b;\n', '  }\n', '\n', '  function changeParameters(uint[] _startPrice, uint[] _priceMilestones, uint[] _priceUps, uint[] _cuts) onlyAdmin public {\n', '    require(_startPrice.length > 0);\n', '    require(_priceUps.length == _priceMilestones.length + 1);\n', '    require(_priceUps.length == _cuts.length);\n', '    for (uint i = 0; i<_priceUps.length; ++i) {\n', '      require(_cuts[i] <= 1000);\n', '      require(_priceUps[i] > 1000 + _cuts[i]);\n', '      if (i < _priceMilestones.length-1) {\n', '        require(_priceMilestones[i] < _priceMilestones[i+1]);\n', '      }\n', '    }\n', '    startPrice = _startPrice;\n', '    priceMilestones = _priceMilestones;\n', '    priceUps = _priceUps;\n', '    cuts = _cuts;\n', '  }\n', '\n', '  function withdrawAll() onlyAdmin public { msg.sender.transfer(this.balance); }\n', '  function withdraw(uint _amount) onlyAdmin public { msg.sender.transfer(_amount); }\n', '  function changeAdmin(address _newAdmin) onlyAdmin public { admin = _newAdmin; }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract Redeem {\n', '\n', '  struct Item {\n', '    address owner;\n', '    uint price;\n', '    uint nextPrice;\n', '    string slogan;\n', '  }\n', '\n', '  address admin;\n', '  uint[] cuts = [50,40,30,30,20];\n', '  uint[] priceUps = [2105,1406,1288,1206,1173];\n', '  uint[] priceMilestones = [20,500,2000,5000];\n', '  uint[] startPrice = [7,7,7,13,13,13,13,13,17,17];\n', '  bool running = true;\n', '\n', '  mapping (uint => Item) items;\n', '  uint[] itemIndices;\n', '  function soldItems() view public returns (uint[]) { return itemIndices; }\n', '\n', '  event OnSold(uint indexed _iItem, address indexed _oldOwner, address indexed _newOwner, uint _oldPrice, uint _newPrice, string _newSlogan);\n', '  \n', '  modifier onlyAdmin() {\n', '    require(msg.sender == admin);\n', '    _;\n', '  }\n', '  modifier enabled() {\n', '    require(running);\n', '    _;\n', '  }\n', '\n', '  function Redeem() public {\n', '    admin = msg.sender;\n', '  }\n', '\n', '  function itemAt(uint _idx) view public returns (uint iItem, address owner, uint price, uint nextPrice, string slogan) {\n', '    Item memory item = items[_idx];\n', '    if (item.price > 0) {\n', '      return (_idx, item.owner, item.price, item.nextPrice, item.slogan);\n', '    } else {\n', '      uint p = startPrice[_idx % startPrice.length];\n', '      return (_idx, item.owner, p, nextPriceOf(p), "");\n', '    }\n', '  }\n', '\n', '  function buy(uint _idx, string _slogan) enabled payable public {\n', '    Item storage item = items[_idx];\n', '    if (item.price == 0) {\n', '      item.price = startPrice[_idx % startPrice.length];\n', '      item.nextPrice = nextPriceOf(item.price);\n', '      itemIndices.push(_idx);\n', '    }\n', '    require(item.price > 0);\n', '    uint curWei = item.price * 1e15;\n', '    require(curWei <= msg.value);\n', '    address oldOwner = item.owner;\n', '    uint oldPrice = item.price;\n', '    if (item.owner != 0x0) {\n', '      require(item.owner != msg.sender);\n', '      item.owner.transfer(curWei * (1000 - cutOf(item.price)) / 1000);\n', '    }\n', '    msg.sender.transfer(msg.value - curWei);\n', '    item.owner = msg.sender;\n', '    item.slogan = _slogan;\n', '    item.price = item.nextPrice;\n', '    item.nextPrice = nextPriceOf(item.price);\n', '    OnSold(_idx, oldOwner, item.owner, oldPrice, item.price, item.slogan);\n', '  }\n', '\n', '  function nextPriceOf(uint _price) view internal returns (uint) {\n', '    for (uint i = 0; i<priceUps.length; ++i) {\n', '      if (i >= priceMilestones.length || _price < priceMilestones[i])\n', '        return _price * priceUps[i] / 1000;\n', '    }\n', '    require(false); //should not happen\n', '    return 0;\n', '  }\n', '  \n', '  function cutOf(uint _price) view internal returns (uint) {\n', '    for (uint i = 0; i<cuts.length; ++i) {\n', '      if (i >= priceMilestones.length || _price < priceMilestones[i])\n', '        return cuts[i];\n', '    }\n', '    require(false); //should not happen\n', '    return 0;\n', '  }\n', '  \n', '  function contractInfo() view public returns (bool, address, uint256, uint[], uint[], uint[], uint[]) {\n', '    return (running, admin, this.balance, startPrice, priceMilestones, cuts, priceUps);\n', '  }\n', '\n', '  function enable(bool b) onlyAdmin public {\n', '    running = b;\n', '  }\n', '\n', '  function changeParameters(uint[] _startPrice, uint[] _priceMilestones, uint[] _priceUps, uint[] _cuts) onlyAdmin public {\n', '    require(_startPrice.length > 0);\n', '    require(_priceUps.length == _priceMilestones.length + 1);\n', '    require(_priceUps.length == _cuts.length);\n', '    for (uint i = 0; i<_priceUps.length; ++i) {\n', '      require(_cuts[i] <= 1000);\n', '      require(_priceUps[i] > 1000 + _cuts[i]);\n', '      if (i < _priceMilestones.length-1) {\n', '        require(_priceMilestones[i] < _priceMilestones[i+1]);\n', '      }\n', '    }\n', '    startPrice = _startPrice;\n', '    priceMilestones = _priceMilestones;\n', '    priceUps = _priceUps;\n', '    cuts = _cuts;\n', '  }\n', '\n', '  function withdrawAll() onlyAdmin public { msg.sender.transfer(this.balance); }\n', '  function withdraw(uint _amount) onlyAdmin public { msg.sender.transfer(_amount); }\n', '  function changeAdmin(address _newAdmin) onlyAdmin public { admin = _newAdmin; }\n', '}']