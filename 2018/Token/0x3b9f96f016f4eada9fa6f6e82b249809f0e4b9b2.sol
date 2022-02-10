['pragma solidity ^0.4.20;\n', '\n', '//*************** SafeMath ***************\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b > 0);\n', '      uint256 c = a / b;\n', '      return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '  }\n', '}\n', '\n', '//*************** Ownable *************** \n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor ()public {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner)public onlyOwner {\n', '      if (newOwner != address(0)) {\n', '        owner = newOwner;\n', '      }\n', '  }\n', '\n', '}\n', '\n', '//************* ERC20 *************** \n', '\n', 'contract ERC20 {\n', '  \n', '  function balanceOf(address who)public constant returns (uint256);\n', '  function transfer(address to, uint256 value)public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value)public returns (bool);\n', '  function allowance(address owner, address spender)public constant returns (uint256);\n', '  function approve(address spender, uint256 value)public returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '//************* WeiLai Token *************\n', '\n', 'contract WeiLaiExToken is ERC20,Ownable {\n', '\tusing SafeMath for uint256;\n', '\n', '\t// Token Info.\n', '\tstring public name;\n', '\tstring public symbol;\n', '\tuint256 public totalSupply;\n', '\tuint256 public constant decimals = 18;\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\taddress[] private walletArr;\n', '    uint walletIdx = 0;\n', '    event FundTransfer(address fundWallet, uint256 amount);\n', '  \n', '\tfunction WeiLaiExToken() public {  \t\n', '\t\tname="WeiLaiExToken";\n', '\t\tsymbol="WT";\n', '\t\ttotalSupply = 2000000000*(10**decimals);\n', '\t\tbalanceOf[msg.sender] = totalSupply;\t\n', '        walletArr.push(0xC050D79CbBC62eaE5F50Fb631aae8C69bdC3c88f);\n', '\t \n', '\t}\n', '\n', '\tfunction balanceOf(address _who)public constant returns (uint256 balance) {\n', '\t    require(_who != 0x0);\n', '\t    return balanceOf[_who];\n', '\t}\n', '\n', '\tfunction _transferFrom(address _from, address _to, uint256 _value)  internal returns (bool) {\n', '\t  require(_from != 0x0);\n', '\t  require(_to != 0x0);\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[_to].add(_value) >= balanceOf[_to]);\n', '      uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '      balanceOf[_from] = balanceOf[_from].sub(_value);\n', '      balanceOf[_to] = balanceOf[_to].add(_value);\n', '      emit Transfer(_from, _to, _value);\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '      return true;\n', '\t}\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool){\t    \n', '\t    return _transferFrom(msg.sender,_to,_value);\n', '\t    \n', '\t}\n', '\t\n', '\tfunction ()public payable {\n', '      _tokenPurchase( );\n', '    }\n', '\n', '    function _tokenPurchase( ) internal {\n', '       require(msg.value >= 1 ether);    \n', '       address wallet = walletArr[walletIdx];\n', '       walletIdx = (walletIdx+1) % walletArr.length;\n', '       wallet.transfer(msg.value);\n', '       emit FundTransfer(wallet, msg.value);\n', '    }\n', '\n', '\n', '\tfunction allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '      require(_owner != 0x0);\n', '      require(_spender != 0x0);\n', '\t  return allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _value)public returns (bool) {\n', '        require(_spender != 0x0);\n', '        require(balanceOf[msg.sender] >= _value);\n', '\t    allowed[msg.sender][_spender] = _value;\n', '\t    emit Approval(msg.sender, _spender, _value);\n', '\t    return true;\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value)public returns (bool) {\n', '\t    require(_from != 0x0);\n', '\t    require(_to != 0x0);\n', '\t    require(_value > 0);\n', '\t    require(allowed[_from][msg.sender] >= _value);\n', '\t    require(balanceOf[_from] >= _value);\n', '\t    require(balanceOf[_to].add(_value) >= balanceOf[_to]);\n', '\t    \n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); \n', '      balanceOf[_from] = balanceOf[_from].sub(_value);\n', '      balanceOf[_to] = balanceOf[_to].add(_value);\n', '            \n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '       \n', '    }\n', ' \n', '\t\n', '}']
['pragma solidity ^0.4.20;\n', '\n', '//*************** SafeMath ***************\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b > 0);\n', '      uint256 c = a / b;\n', '      return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '  }\n', '}\n', '\n', '//*************** Ownable *************** \n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  constructor ()public {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner)public onlyOwner {\n', '      if (newOwner != address(0)) {\n', '        owner = newOwner;\n', '      }\n', '  }\n', '\n', '}\n', '\n', '//************* ERC20 *************** \n', '\n', 'contract ERC20 {\n', '  \n', '  function balanceOf(address who)public constant returns (uint256);\n', '  function transfer(address to, uint256 value)public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value)public returns (bool);\n', '  function allowance(address owner, address spender)public constant returns (uint256);\n', '  function approve(address spender, uint256 value)public returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '//************* WeiLai Token *************\n', '\n', 'contract WeiLaiExToken is ERC20,Ownable {\n', '\tusing SafeMath for uint256;\n', '\n', '\t// Token Info.\n', '\tstring public name;\n', '\tstring public symbol;\n', '\tuint256 public totalSupply;\n', '\tuint256 public constant decimals = 18;\n', '    mapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\taddress[] private walletArr;\n', '    uint walletIdx = 0;\n', '    event FundTransfer(address fundWallet, uint256 amount);\n', '  \n', '\tfunction WeiLaiExToken() public {  \t\n', '\t\tname="WeiLaiExToken";\n', '\t\tsymbol="WT";\n', '\t\ttotalSupply = 2000000000*(10**decimals);\n', '\t\tbalanceOf[msg.sender] = totalSupply;\t\n', '        walletArr.push(0xC050D79CbBC62eaE5F50Fb631aae8C69bdC3c88f);\n', '\t \n', '\t}\n', '\n', '\tfunction balanceOf(address _who)public constant returns (uint256 balance) {\n', '\t    require(_who != 0x0);\n', '\t    return balanceOf[_who];\n', '\t}\n', '\n', '\tfunction _transferFrom(address _from, address _to, uint256 _value)  internal returns (bool) {\n', '\t  require(_from != 0x0);\n', '\t  require(_to != 0x0);\n', '      require(balanceOf[_from] >= _value);\n', '      require(balanceOf[_to].add(_value) >= balanceOf[_to]);\n', '      uint256 previousBalances = balanceOf[_from] + balanceOf[_to];\n', '      balanceOf[_from] = balanceOf[_from].sub(_value);\n', '      balanceOf[_to] = balanceOf[_to].add(_value);\n', '      emit Transfer(_from, _to, _value);\n', '      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '      return true;\n', '\t}\n', '\t\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool){\t    \n', '\t    return _transferFrom(msg.sender,_to,_value);\n', '\t    \n', '\t}\n', '\t\n', '\tfunction ()public payable {\n', '      _tokenPurchase( );\n', '    }\n', '\n', '    function _tokenPurchase( ) internal {\n', '       require(msg.value >= 1 ether);    \n', '       address wallet = walletArr[walletIdx];\n', '       walletIdx = (walletIdx+1) % walletArr.length;\n', '       wallet.transfer(msg.value);\n', '       emit FundTransfer(wallet, msg.value);\n', '    }\n', '\n', '\n', '\tfunction allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '      require(_owner != 0x0);\n', '      require(_spender != 0x0);\n', '\t  return allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _value)public returns (bool) {\n', '        require(_spender != 0x0);\n', '        require(balanceOf[msg.sender] >= _value);\n', '\t    allowed[msg.sender][_spender] = _value;\n', '\t    emit Approval(msg.sender, _spender, _value);\n', '\t    return true;\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value)public returns (bool) {\n', '\t    require(_from != 0x0);\n', '\t    require(_to != 0x0);\n', '\t    require(_value > 0);\n', '\t    require(allowed[_from][msg.sender] >= _value);\n', '\t    require(balanceOf[_from] >= _value);\n', '\t    require(balanceOf[_to].add(_value) >= balanceOf[_to]);\n', '\t    \n', '      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); \n', '      balanceOf[_from] = balanceOf[_from].sub(_value);\n', '      balanceOf[_to] = balanceOf[_to].add(_value);\n', '            \n', '      emit Transfer(_from, _to, _value);\n', '      return true;\n', '       \n', '    }\n', ' \n', '\t\n', '}']
