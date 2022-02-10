['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _owner) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title Owned\n', ' */\n', 'contract Owned {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 token\n', ' */\n', 'contract ERC20Token is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  uint256 public totalToken;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(balances[msg.sender] >= _value);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(balances[_from] >= _value);\n', '    require(allowed[_from][msg.sender] >= _value);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalToken;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title PandaGold Token\n', ' */\n', 'contract PandaGoldToken is ERC20Token, Owned {\n', '\n', '  string  public constant name     = "PandaGold Token";\n', '  string  public constant symbol   = "PANDA";\n', '  uint256 public constant decimals = 18;\n', '\n', '  uint256 public constant initialToken     = 2000000000 * (10 ** decimals);\n', '\n', '  uint256 public constant publicToken      = initialToken * 55 / 100; // 55%\n', '  uint256 public constant founderToken     = initialToken * 10 / 100; // 10%\n', '  uint256 public constant developmentToken = initialToken * 10 / 100; // 10%\n', '  uint256 public constant bountyToken      = initialToken *  5 / 100; //  5%\n', '  uint256 public constant privateSaleToken = initialToken * 10 / 100; // 10%\n', '  uint256 public constant preSaleToken     = initialToken * 10 / 100; // 10%\n', '\n', '  address public constant founderAddress     = 0x003d9d0ebfbDa7AEc39EEAEcc4D47Dd18eA3c495;\n', '  address public constant developmentAddress = 0x00aCede2bdf8aecCedb0B669DbA662edC93D6178;\n', '  address public constant bountyAddress      = 0x00D42B2864C6E383b1FD9E56540c43d3815D486e;\n', '  address public constant privateSaleAddress = 0x00507Bf4d07A693fB7C4F9d846d58951042260aa;\n', '  address public constant preSaleAddress     = 0x00241bD9aa09b440DE23835BB2EE0a45926Bb61A;\n', '  address public constant rescueAddress      = 0x005F25Bc2386BfE9E5612f2C437c5e5E45720874;\n', '\n', '  uint256 public constant founderLockEndTime     = 1577836800; // 2020-01-01 00:00:00 GMT\n', '  uint256 public constant developmentLockEndTime = 1559347200; // 2019-06-01 00:00:00 GMT\n', '  uint256 public constant bountyLockEndTime      = 1543363200; // 2018-11-28 00:00:00 GMT\n', '  uint256 public constant privateSaleLockEndTime = 1546300800; // 2019-01-01 00:00:00 GMT\n', '  uint256 public constant preSaleLockEndTime     = 1543363200; // 2018-11-28 00:00:00 GMT\n', '\n', '  uint256 public constant maxDestroyThreshold = initialToken / 2;\n', '  uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 50;\n', '  \n', '  mapping(address => bool) lockAddresses;\n', '\n', '  uint256 public destroyedToken;\n', '\n', '  event Burn(address indexed _burner, uint256 _value);\n', '\n', '  constructor() public {\n', '    totalToken     = initialToken;\n', '\n', '    balances[msg.sender]         = publicToken;\n', '    balances[founderAddress]     = founderToken;\n', '    balances[developmentAddress] = developmentToken;\n', '    balances[bountyAddress]      = bountyToken;\n', '    balances[privateSaleAddress] = privateSaleToken;\n', '    balances[preSaleAddress]     = preSaleToken;\n', '\n', '    emit Transfer(0x0, msg.sender, publicToken);\n', '    emit Transfer(0x0, founderAddress, founderToken);\n', '    emit Transfer(0x0, developmentAddress, developmentToken);\n', '    emit Transfer(0x0, bountyAddress, bountyToken);\n', '    emit Transfer(0x0, privateSaleAddress, privateSaleToken);\n', '    emit Transfer(0x0, preSaleAddress, preSaleToken);\n', '\n', '    lockAddresses[founderAddress]     = true;\n', '    lockAddresses[developmentAddress] = true;\n', '    lockAddresses[bountyAddress]      = true;\n', '    lockAddresses[privateSaleAddress] = true;\n', '    lockAddresses[preSaleAddress]     = true;\n', '\n', '    destroyedToken = 0;\n', '  }\n', '\n', '  modifier transferable(address _addr) {\n', '    require(!lockAddresses[_addr]);\n', '    _;\n', '  }\n', '\n', '  function unlock() public onlyOwner {\n', '    if (lockAddresses[founderAddress] && now >= founderLockEndTime)\n', '      lockAddresses[founderAddress] = false;\n', '    if (lockAddresses[developmentAddress] && now >= developmentLockEndTime)\n', '      lockAddresses[developmentAddress] = false;\n', '    if (lockAddresses[bountyAddress] && now >= bountyLockEndTime)\n', '      lockAddresses[bountyAddress] = false;\n', '    if (lockAddresses[privateSaleAddress] && now >= privateSaleLockEndTime)\n', '      lockAddresses[privateSaleAddress] = false;\n', '    if (lockAddresses[preSaleAddress] && now >= preSaleLockEndTime)\n', '      lockAddresses[preSaleAddress] = false;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function burn(uint256 _value) public onlyOwner returns (bool) {\n', '    require(balances[msg.sender] >= _value);\n', '    require(maxBurnThreshold >= _value);\n', '    require(maxDestroyThreshold >= destroyedToken.add(_value));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalToken = totalToken.sub(_value);\n', '    destroyedToken = destroyedToken.add(_value);\n', '    emit Transfer(msg.sender, 0x0, _value);\n', '    emit Burn(msg.sender, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {\n', '    return ERC20(_tokenAddress).transfer(rescueAddress, _value);\n', '  }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' */\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _owner) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool);\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  function allowance(address _owner, address _spender) public view returns (uint256);\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', '/**\n', ' * @title Owned\n', ' */\n', 'contract Owned {\n', '  address public owner;\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '  \n', '  modifier onlyOwner {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title ERC20 token\n', ' */\n', 'contract ERC20Token is ERC20 {\n', '  using SafeMath for uint256;\n', '\n', '  mapping(address => uint256) balances;\n', '  mapping (address => mapping (address => uint256)) allowed;\n', '  uint256 public totalToken;\n', '\n', '  function transfer(address _to, uint256 _value) public returns (bool) {\n', '    require(balances[msg.sender] >= _value);\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    emit Transfer(msg.sender, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '    require(balances[_from] >= _value);\n', '    require(allowed[_from][msg.sender] >= _value);\n', '\n', '    balances[_from] = balances[_from].sub(_value);\n', '    balances[_to] = balances[_to].add(_value);\n', '    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '    emit Transfer(_from, _to, _value);\n', '    return true;\n', '  }\n', '\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalToken;\n', '  }\n', '\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool) {\n', '    allowed[msg.sender][_spender] = _value;\n', '    emit Approval(msg.sender, _spender, _value);\n', '    return true;\n', '  }\n', '\n', '  function allowance(address _owner, address _spender) public view returns (uint256) {\n', '    return allowed[_owner][_spender];\n', '  }\n', '}\n', '\n', '/**\n', ' * @title PandaGold Token\n', ' */\n', 'contract PandaGoldToken is ERC20Token, Owned {\n', '\n', '  string  public constant name     = "PandaGold Token";\n', '  string  public constant symbol   = "PANDA";\n', '  uint256 public constant decimals = 18;\n', '\n', '  uint256 public constant initialToken     = 2000000000 * (10 ** decimals);\n', '\n', '  uint256 public constant publicToken      = initialToken * 55 / 100; // 55%\n', '  uint256 public constant founderToken     = initialToken * 10 / 100; // 10%\n', '  uint256 public constant developmentToken = initialToken * 10 / 100; // 10%\n', '  uint256 public constant bountyToken      = initialToken *  5 / 100; //  5%\n', '  uint256 public constant privateSaleToken = initialToken * 10 / 100; // 10%\n', '  uint256 public constant preSaleToken     = initialToken * 10 / 100; // 10%\n', '\n', '  address public constant founderAddress     = 0x003d9d0ebfbDa7AEc39EEAEcc4D47Dd18eA3c495;\n', '  address public constant developmentAddress = 0x00aCede2bdf8aecCedb0B669DbA662edC93D6178;\n', '  address public constant bountyAddress      = 0x00D42B2864C6E383b1FD9E56540c43d3815D486e;\n', '  address public constant privateSaleAddress = 0x00507Bf4d07A693fB7C4F9d846d58951042260aa;\n', '  address public constant preSaleAddress     = 0x00241bD9aa09b440DE23835BB2EE0a45926Bb61A;\n', '  address public constant rescueAddress      = 0x005F25Bc2386BfE9E5612f2C437c5e5E45720874;\n', '\n', '  uint256 public constant founderLockEndTime     = 1577836800; // 2020-01-01 00:00:00 GMT\n', '  uint256 public constant developmentLockEndTime = 1559347200; // 2019-06-01 00:00:00 GMT\n', '  uint256 public constant bountyLockEndTime      = 1543363200; // 2018-11-28 00:00:00 GMT\n', '  uint256 public constant privateSaleLockEndTime = 1546300800; // 2019-01-01 00:00:00 GMT\n', '  uint256 public constant preSaleLockEndTime     = 1543363200; // 2018-11-28 00:00:00 GMT\n', '\n', '  uint256 public constant maxDestroyThreshold = initialToken / 2;\n', '  uint256 public constant maxBurnThreshold    = maxDestroyThreshold / 50;\n', '  \n', '  mapping(address => bool) lockAddresses;\n', '\n', '  uint256 public destroyedToken;\n', '\n', '  event Burn(address indexed _burner, uint256 _value);\n', '\n', '  constructor() public {\n', '    totalToken     = initialToken;\n', '\n', '    balances[msg.sender]         = publicToken;\n', '    balances[founderAddress]     = founderToken;\n', '    balances[developmentAddress] = developmentToken;\n', '    balances[bountyAddress]      = bountyToken;\n', '    balances[privateSaleAddress] = privateSaleToken;\n', '    balances[preSaleAddress]     = preSaleToken;\n', '\n', '    emit Transfer(0x0, msg.sender, publicToken);\n', '    emit Transfer(0x0, founderAddress, founderToken);\n', '    emit Transfer(0x0, developmentAddress, developmentToken);\n', '    emit Transfer(0x0, bountyAddress, bountyToken);\n', '    emit Transfer(0x0, privateSaleAddress, privateSaleToken);\n', '    emit Transfer(0x0, preSaleAddress, preSaleToken);\n', '\n', '    lockAddresses[founderAddress]     = true;\n', '    lockAddresses[developmentAddress] = true;\n', '    lockAddresses[bountyAddress]      = true;\n', '    lockAddresses[privateSaleAddress] = true;\n', '    lockAddresses[preSaleAddress]     = true;\n', '\n', '    destroyedToken = 0;\n', '  }\n', '\n', '  modifier transferable(address _addr) {\n', '    require(!lockAddresses[_addr]);\n', '    _;\n', '  }\n', '\n', '  function unlock() public onlyOwner {\n', '    if (lockAddresses[founderAddress] && now >= founderLockEndTime)\n', '      lockAddresses[founderAddress] = false;\n', '    if (lockAddresses[developmentAddress] && now >= developmentLockEndTime)\n', '      lockAddresses[developmentAddress] = false;\n', '    if (lockAddresses[bountyAddress] && now >= bountyLockEndTime)\n', '      lockAddresses[bountyAddress] = false;\n', '    if (lockAddresses[privateSaleAddress] && now >= privateSaleLockEndTime)\n', '      lockAddresses[privateSaleAddress] = false;\n', '    if (lockAddresses[preSaleAddress] && now >= preSaleLockEndTime)\n', '      lockAddresses[preSaleAddress] = false;\n', '  }\n', '\n', '  function transfer(address _to, uint256 _value) public transferable(msg.sender) returns (bool) {\n', '    return super.transfer(_to, _value);\n', '  }\n', '\n', '  function approve(address _spender, uint256 _value) public transferable(msg.sender) returns (bool) {\n', '    return super.approve(_spender, _value);\n', '  }\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value) public transferable(_from) returns (bool) {\n', '    return super.transferFrom(_from, _to, _value);\n', '  }\n', '\n', '  function burn(uint256 _value) public onlyOwner returns (bool) {\n', '    require(balances[msg.sender] >= _value);\n', '    require(maxBurnThreshold >= _value);\n', '    require(maxDestroyThreshold >= destroyedToken.add(_value));\n', '\n', '    balances[msg.sender] = balances[msg.sender].sub(_value);\n', '    totalToken = totalToken.sub(_value);\n', '    destroyedToken = destroyedToken.add(_value);\n', '    emit Transfer(msg.sender, 0x0, _value);\n', '    emit Burn(msg.sender, _value);\n', '    return true;\n', '  }\n', '\n', '  function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {\n', '    return ERC20(_tokenAddress).transfer(rescueAddress, _value);\n', '  }\n', '}']
