['// Congratulations! Its your free airdrop token! Get 6 USD in EToken FREE!\n', '// Promocode: 6forfree\n', '// More: tokensale.endo.im/promo/\n', '// Join us: https://t.me/endo_en\n', '// ENDO is a Protocol that solves the problem of certified information tracking and encrypted data storage. \n', '// The ENDO ecosystem allows organisations and users to participate in information and service exchange through the EToken.\n', '\n', '// おめでとうございます！これはあなたの無料エアドロップのトークンとなります！EToken建ての6ドルを無償で獲得してください。\n', '// プロモーションコード：6forfree\u3000\n', '// 詳細はこちら：tokensale.endo.im/promo/\n', '// こちらの公式Telegramクループにご参加ください：https://t.me/endo_jp\u3000\n', '// ENDOとは認定された情報の追跡と暗号化されたデータの保管に関する問題を解決するプロトコルです。 \n', '// ENDOエコシステムでは、ユーザーと企業がETokenを使用して情報の交換やサービスの受領を出来ます。\n', '\n', '// 恭喜！ 它是你的免费空投代币！ 免费获得6美元的EToken！\n', '// 促销代码：6forfree\n', '// 更多：tokensale.endo.im/promo/\n', '// 加入我们：https://t.me/endo_cn\n', '// ENDO是一个解决认证信息跟踪和加密数据存储问题的协议。\n', '// ENDO生态系统允许组织和用户通过EToken参与信息和服务交换。\n', '\n', '// 축하합니다! 무료 에어드랍 토큰! EToken에서 6 받으세요!\n', '// 프로모션 코드 : 6forfree\n', '// 더보기 : tokensale.endo.im/promo/\n', '// 우리와 함께하십시오 : https://t.me/endo_ko\n', '// ENDO는 정보를 안전하게 공유하고 검증할 수 있도록 하는 프로젝트 입니다.\n', '// ENDO 토큰으로 서류를 검증하고 암호화 할 수 있습니다.\n', '\n', '// Поздравляем! Ваш персональный Airdrop уже готов! Получите 6 USD в эквиваленте EToken бесплатно!\n', '// Промокод: 6forfree\n', '// Узнать больше: tokensale.endo.im/promo/\n', '// Присоединяйтесь к нам: https://t.me/endo_ru\n', '// ENDO – это протокол, решающий проблему отслеживания подтвержденной информации и хранения зашифрованных данных. \n', '// Экосистема ENDO позволяет организациям и пользователям принимать участие в процессе обмены информацией и пользоваться услугами с помощью токена ENDO.\n', '\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public returns (uint256);\n', '  //function transfer(address to, uint256 value) public returns(bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public returns (uint256);\n', '  //function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '  //function approve(address spender, uint256 value) public returns(bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) public {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '  function balanceOf(address _owner) public returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  function transferFrom(address _from, address _to, uint256 _value) public {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '  function approve(address _spender, uint256 _value) public {\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  function allowance(address _owner, address _spender) public returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  string public name = "ENDO.network Promo Token";\n', '  string public symbol = "ETP";\n', '  uint256 public decimals = 18;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    if(mintingFinished) revert();\n', '    _;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract Airdrop {\n', '  using SafeMath for uint256;\n', '\n', '  MintableToken public token;\n', '  \n', '  uint256 public currentTokenCount;\n', '  address public owner;\n', '  uint256 public maxTokenCount;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function Airdrop() public {\n', '    token = createTokenContract();\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  function sendToken(address[] recipients, uint256 values) public {\n', '    for (uint256 i = 0; i < recipients.length; i++) {\n', '      token.mint(recipients[i], values);\n', '    }\n', '  }\n', '\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '}']
['// Congratulations! Its your free airdrop token! Get 6 USD in EToken FREE!\n', '// Promocode: 6forfree\n', '// More: tokensale.endo.im/promo/\n', '// Join us: https://t.me/endo_en\n', '// ENDO is a Protocol that solves the problem of certified information tracking and encrypted data storage. \n', '// The ENDO ecosystem allows organisations and users to participate in information and service exchange through the EToken.\n', '\n', '// おめでとうございます！これはあなたの無料エアドロップのトークンとなります！EToken建ての6ドルを無償で獲得してください。\n', '// プロモーションコード：6forfree\u3000\n', '// 詳細はこちら：tokensale.endo.im/promo/\n', '// こちらの公式Telegramクループにご参加ください：https://t.me/endo_jp\u3000\n', '// ENDOとは認定された情報の追跡と暗号化されたデータの保管に関する問題を解決するプロトコルです。 \n', '// ENDOエコシステムでは、ユーザーと企業がETokenを使用して情報の交換やサービスの受領を出来ます。\n', '\n', '// 恭喜！ 它是你的免费空投代币！ 免费获得6美元的EToken！\n', '// 促销代码：6forfree\n', '// 更多：tokensale.endo.im/promo/\n', '// 加入我们：https://t.me/endo_cn\n', '// ENDO是一个解决认证信息跟踪和加密数据存储问题的协议。\n', '// ENDO生态系统允许组织和用户通过EToken参与信息和服务交换。\n', '\n', '// 축하합니다! 무료 에어드랍 토큰! EToken에서 6 받으세요!\n', '// 프로모션 코드 : 6forfree\n', '// 더보기 : tokensale.endo.im/promo/\n', '// 우리와 함께하십시오 : https://t.me/endo_ko\n', '// ENDO는 정보를 안전하게 공유하고 검증할 수 있도록 하는 프로젝트 입니다.\n', '// ENDO 토큰으로 서류를 검증하고 암호화 할 수 있습니다.\n', '\n', '// Поздравляем! Ваш персональный Airdrop уже готов! Получите 6 USD в эквиваленте EToken бесплатно!\n', '// Промокод: 6forfree\n', '// Узнать больше: tokensale.endo.im/promo/\n', '// Присоединяйтесь к нам: https://t.me/endo_ru\n', '// ENDO – это протокол, решающий проблему отслеживания подтвержденной информации и хранения зашифрованных данных. \n', '// Экосистема ENDO позволяет организациям и пользователям принимать участие в процессе обмены информацией и пользоваться услугами с помощью токена ENDO.\n', '\n', '\n', 'pragma solidity ^0.4.11;\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public returns (uint256);\n', '  //function transfer(address to, uint256 value) public returns(bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public returns (uint256);\n', '  //function transferFrom(address from, address to, uint256 value) public returns(bool);\n', '  //function approve(address spender, uint256 value) public returns(bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'contract BasicToken is ERC20Basic {\n', '  using SafeMath for uint256;\n', '  mapping(address => uint256) balances;\n', '  function transfer(address _to, uint256 _value) public {\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    Transfer(msg.sender, _to, _value);\n', '  }\n', '  function balanceOf(address _owner) public returns (uint256 balance) {\n', '    return balances[_owner];\n', '  }\n', '}\n', 'contract StandardToken is ERC20, BasicToken {\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  function transferFrom(address _from, address _to, uint256 _value) public {\n', '    var _allowance = allowed[_from][msg.sender];\n', '    balances[_to] = balances[_to].add(_value);\n', '    balances[_from] = balances[_from].sub(_value);\n', '    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '    Transfer(_from, _to, _value);\n', '  }\n', '  function approve(address _spender, uint256 _value) public {\n', '    if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '    allowed[msg.sender][_spender] = _value;\n', '    Approval(msg.sender, _spender, _value);\n', '  }\n', '  function allowance(address _owner, address _spender) public returns (uint256 remaining) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', 'contract Ownable {\n', '  address public owner;\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      revert();\n', '    }\n', '    _;\n', '  }\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', 'contract MintableToken is StandardToken, Ownable {\n', '  event Mint(address indexed to, uint256 amount);\n', '  event MintFinished();\n', '\n', '  string public name = "ENDO.network Promo Token";\n', '  string public symbol = "ETP";\n', '  uint256 public decimals = 18;\n', '\n', '  bool public mintingFinished = false;\n', '\n', '  modifier canMint() {\n', '    if(mintingFinished) revert();\n', '    _;\n', '  }\n', '\n', '  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {\n', '    totalSupply = totalSupply.add(_amount);\n', '    balances[_to] = balances[_to].add(_amount);\n', '    Mint(_to, _amount);\n', '    return true;\n', '  }\n', '\n', '  function finishMinting() onlyOwner public returns (bool) {\n', '    mintingFinished = true;\n', '    MintFinished();\n', '    return true;\n', '  }\n', '}\n', '\n', 'contract Airdrop {\n', '  using SafeMath for uint256;\n', '\n', '  MintableToken public token;\n', '  \n', '  uint256 public currentTokenCount;\n', '  address public owner;\n', '  uint256 public maxTokenCount;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function Airdrop() public {\n', '    token = createTokenContract();\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  function sendToken(address[] recipients, uint256 values) public {\n', '    for (uint256 i = 0; i < recipients.length; i++) {\n', '      token.mint(recipients[i], values);\n', '    }\n', '  }\n', '\n', '  function createTokenContract() internal returns (MintableToken) {\n', '    return new MintableToken();\n', '  }\n', '\n', '}']