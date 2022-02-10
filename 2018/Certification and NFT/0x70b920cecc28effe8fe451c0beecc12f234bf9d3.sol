['// GYM Ledger Token Sale Contract - Project website: www.gymledger.com\n', '\n', '// GYM Reward, LLC\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner, "Only owner can call this function");\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0), "Valid address is required");\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenContract {\n', '  function mintTo(address _to, uint256 _amount) external;\n', '}\n', '\n', 'contract LGRSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  address public walletAddress;\n', '  TokenContract public tkn;\n', '  uint256[3] public pricePerToken = [1400 szabo, 1500 szabo, 2000 szabo];\n', '  uint256[3] public levelEndDate = [1539648000, 1541030400, 1546300740];\n', '  uint256 public startDate = 1538352000;\n', '  uint8 public currentLevel;\n', '  uint256 public tokensSold;\n', '\n', '  constructor() public {\n', '    currentLevel = 0;\n', '    tokensSold = 0;\n', '    walletAddress = 0xE38cc3F48b4F98Cb3577aC75bB96DBBc87bc57d6;\n', '    tkn = TokenContract(0x7172433857c83A68F6Dc98EdE4391c49785feD0B);\n', '  }\n', '\n', '  function() public payable {\n', '    \n', '    if (levelEndDate[currentLevel] < now) {\n', '      currentLevel += 1;\n', '      if (currentLevel > 2) {\n', '        msg.sender.transfer(msg.value);\n', '      } else {\n', '        executeSell();\n', '      }\n', '    } else {\n', '      executeSell();\n', '    }\n', '  }\n', '  \n', '  function executeSell() private {\n', '    uint256 tokensToSell;\n', '    require(msg.value >= pricePerToken[currentLevel], "Minimum amount is 1 token");\n', '    tokensToSell = msg.value.div(pricePerToken[currentLevel]);\n', '    tkn.mintTo(msg.sender, tokensToSell);\n', '    tokensSold = tokensSold.add(tokensToSell);\n', '    walletAddress.transfer(msg.value);\n', '  }\n', '\n', '  function killContract(bool _kill) public onlyOwner {\n', '    if (_kill == true) {\n', '      selfdestruct(owner);\n', '    }\n', '  }\n', '\n', '  function setWallet(address _wallet) public onlyOwner {\n', '    walletAddress = _wallet;\n', '  }\n', '\n', '  function setLevelEndDate(uint256 _level, uint256 _date) public onlyOwner {\n', '    levelEndDate[_level] = _date;\n', '  }\n', '\n', '}']
['// GYM Ledger Token Sale Contract - Project website: www.gymledger.com\n', '\n', '// GYM Reward, LLC\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner, "Only owner can call this function");\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0), "Valid address is required");\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'interface TokenContract {\n', '  function mintTo(address _to, uint256 _amount) external;\n', '}\n', '\n', 'contract LGRSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  address public walletAddress;\n', '  TokenContract public tkn;\n', '  uint256[3] public pricePerToken = [1400 szabo, 1500 szabo, 2000 szabo];\n', '  uint256[3] public levelEndDate = [1539648000, 1541030400, 1546300740];\n', '  uint256 public startDate = 1538352000;\n', '  uint8 public currentLevel;\n', '  uint256 public tokensSold;\n', '\n', '  constructor() public {\n', '    currentLevel = 0;\n', '    tokensSold = 0;\n', '    walletAddress = 0xE38cc3F48b4F98Cb3577aC75bB96DBBc87bc57d6;\n', '    tkn = TokenContract(0x7172433857c83A68F6Dc98EdE4391c49785feD0B);\n', '  }\n', '\n', '  function() public payable {\n', '    \n', '    if (levelEndDate[currentLevel] < now) {\n', '      currentLevel += 1;\n', '      if (currentLevel > 2) {\n', '        msg.sender.transfer(msg.value);\n', '      } else {\n', '        executeSell();\n', '      }\n', '    } else {\n', '      executeSell();\n', '    }\n', '  }\n', '  \n', '  function executeSell() private {\n', '    uint256 tokensToSell;\n', '    require(msg.value >= pricePerToken[currentLevel], "Minimum amount is 1 token");\n', '    tokensToSell = msg.value.div(pricePerToken[currentLevel]);\n', '    tkn.mintTo(msg.sender, tokensToSell);\n', '    tokensSold = tokensSold.add(tokensToSell);\n', '    walletAddress.transfer(msg.value);\n', '  }\n', '\n', '  function killContract(bool _kill) public onlyOwner {\n', '    if (_kill == true) {\n', '      selfdestruct(owner);\n', '    }\n', '  }\n', '\n', '  function setWallet(address _wallet) public onlyOwner {\n', '    walletAddress = _wallet;\n', '  }\n', '\n', '  function setLevelEndDate(uint256 _level, uint256 _date) public onlyOwner {\n', '    levelEndDate[_level] = _date;\n', '  }\n', '\n', '}']