['pragma solidity 0.4.17;\n', '\n', '// import "./FunderSmartToken.sol";\n', '\n', 'contract PreSale {\n', '\n', '  address private deployer;\n', '\n', '  // for performing allowed transfer\n', '  address private FunderSmartTokenAddress = 0x0;\n', '  address private FundersTokenCentral = 0x0;\n', '\n', '  // 1 eth = 150 fst\n', '  uint256 public oneEtherIsHowMuchFST = 150;\n', '\n', '  // uint256 public startTime = 0;\n', '  uint256 public startTime = 1506052800; // 2017/09/22\n', '  uint256 public endTime   = 1508731200; // 2017/10/22\n', '\n', '  uint256 public soldTokenValue = 0;\n', '  uint256 public preSaleHardCap = 330000000 * (10 ** 18) * 2 / 100; // presale 2% hard cap amount\n', '\n', '  event BuyEvent (address buyer, string email, uint256 etherValue, uint256 tokenValue);\n', '\n', '  function PreSale () public {\n', '    deployer = msg.sender;\n', '  }\n', '\n', '  // PreSale Contract 必須先從 Funder Smart Token approve 過\n', '  function buyFunderSmartToken (string _email, string _code) payable public returns (bool) {\n', '    require(FunderSmartTokenAddress != 0x0); // 需初始化過 token contract 位址\n', '    require(FundersTokenCentral != 0x0); // 需初始化過 fstk 中央帳戶\n', '    require(msg.value >= 1 ether); // 人們要至少用 1 ether 買 token\n', '    require(now >= startTime && now <= endTime); // presale 舉辦期間\n', '    require(soldTokenValue <= preSaleHardCap); // 累積 presale 量不得超過 fst 總發行量 2%\n', '\n', '    uint256 _tokenValue = msg.value * oneEtherIsHowMuchFST;\n', '\n', '    // 35%\n', '    if (keccak256(_code) == 0xde7683d6497212fbd59b6a6f902a01c91a09d9a070bba7506dcc0b309b358eed) {\n', '      _tokenValue = _tokenValue * 135 / 100;\n', '    }\n', '\n', '    // 30%\n', '    if (keccak256(_code) == 0x65b236bfb931f493eb9e6f3db8d461f1f547f2f3a19e33a7aeb24c7e297c926a) {\n', '      _tokenValue = _tokenValue * 130 / 100;\n', '    }\n', '\n', '    // 25%\n', '    if (keccak256(_code) == 0x274125681e11c33f71574f123a20cfd59ed25e64d634078679014fa3a872575c) {\n', '      _tokenValue = _tokenValue * 125 / 100;\n', '    }\n', '\n', '    // 將 FST 從 FundersTokenCentral 轉至 msg.sender\n', '    if (FunderSmartTokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), FundersTokenCentral, msg.sender, _tokenValue) != true) {\n', '      revert();\n', '    }\n', '\n', '    BuyEvent(msg.sender, _email, msg.value, _tokenValue);\n', '\n', '    soldTokenValue = soldTokenValue + _tokenValue;\n', '\n', '    return true;\n', '  }\n', '\n', '  // 把以太幣傳出去\n', '  function transferOut (address _to, uint256 _etherValue) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    _to.transfer(_etherValue);\n', '    return true;\n', '  }\n', '\n', '  // 指定 FST Token Contract (FunderSmartTokenAddress)\n', '  function setFSTAddress (address _funderSmartTokenAddress) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    FunderSmartTokenAddress = _funderSmartTokenAddress;\n', '    return true;\n', '  }\n', '\n', '  // 指定 FSTK 主帳 (FundersTokenCentral)\n', '  function setFSTKCentral (address _fundersTokenCentral) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    FundersTokenCentral = _fundersTokenCentral;\n', '    return true;\n', '  }\n', '\n', '  function () public {}\n', '\n', '}']
['pragma solidity 0.4.17;\n', '\n', '// import "./FunderSmartToken.sol";\n', '\n', 'contract PreSale {\n', '\n', '  address private deployer;\n', '\n', '  // for performing allowed transfer\n', '  address private FunderSmartTokenAddress = 0x0;\n', '  address private FundersTokenCentral = 0x0;\n', '\n', '  // 1 eth = 150 fst\n', '  uint256 public oneEtherIsHowMuchFST = 150;\n', '\n', '  // uint256 public startTime = 0;\n', '  uint256 public startTime = 1506052800; // 2017/09/22\n', '  uint256 public endTime   = 1508731200; // 2017/10/22\n', '\n', '  uint256 public soldTokenValue = 0;\n', '  uint256 public preSaleHardCap = 330000000 * (10 ** 18) * 2 / 100; // presale 2% hard cap amount\n', '\n', '  event BuyEvent (address buyer, string email, uint256 etherValue, uint256 tokenValue);\n', '\n', '  function PreSale () public {\n', '    deployer = msg.sender;\n', '  }\n', '\n', '  // PreSale Contract 必須先從 Funder Smart Token approve 過\n', '  function buyFunderSmartToken (string _email, string _code) payable public returns (bool) {\n', '    require(FunderSmartTokenAddress != 0x0); // 需初始化過 token contract 位址\n', '    require(FundersTokenCentral != 0x0); // 需初始化過 fstk 中央帳戶\n', '    require(msg.value >= 1 ether); // 人們要至少用 1 ether 買 token\n', '    require(now >= startTime && now <= endTime); // presale 舉辦期間\n', '    require(soldTokenValue <= preSaleHardCap); // 累積 presale 量不得超過 fst 總發行量 2%\n', '\n', '    uint256 _tokenValue = msg.value * oneEtherIsHowMuchFST;\n', '\n', '    // 35%\n', '    if (keccak256(_code) == 0xde7683d6497212fbd59b6a6f902a01c91a09d9a070bba7506dcc0b309b358eed) {\n', '      _tokenValue = _tokenValue * 135 / 100;\n', '    }\n', '\n', '    // 30%\n', '    if (keccak256(_code) == 0x65b236bfb931f493eb9e6f3db8d461f1f547f2f3a19e33a7aeb24c7e297c926a) {\n', '      _tokenValue = _tokenValue * 130 / 100;\n', '    }\n', '\n', '    // 25%\n', '    if (keccak256(_code) == 0x274125681e11c33f71574f123a20cfd59ed25e64d634078679014fa3a872575c) {\n', '      _tokenValue = _tokenValue * 125 / 100;\n', '    }\n', '\n', '    // 將 FST 從 FundersTokenCentral 轉至 msg.sender\n', '    if (FunderSmartTokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), FundersTokenCentral, msg.sender, _tokenValue) != true) {\n', '      revert();\n', '    }\n', '\n', '    BuyEvent(msg.sender, _email, msg.value, _tokenValue);\n', '\n', '    soldTokenValue = soldTokenValue + _tokenValue;\n', '\n', '    return true;\n', '  }\n', '\n', '  // 把以太幣傳出去\n', '  function transferOut (address _to, uint256 _etherValue) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    _to.transfer(_etherValue);\n', '    return true;\n', '  }\n', '\n', '  // 指定 FST Token Contract (FunderSmartTokenAddress)\n', '  function setFSTAddress (address _funderSmartTokenAddress) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    FunderSmartTokenAddress = _funderSmartTokenAddress;\n', '    return true;\n', '  }\n', '\n', '  // 指定 FSTK 主帳 (FundersTokenCentral)\n', '  function setFSTKCentral (address _fundersTokenCentral) public returns (bool) {\n', '    require(msg.sender == deployer);\n', '    FundersTokenCentral = _fundersTokenCentral;\n', '    return true;\n', '  }\n', '\n', '  function () public {}\n', '\n', '}']
