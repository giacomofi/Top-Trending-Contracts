['pragma solidity ^0.4.19;\n', '\n', '//*************** SafeMath ***************\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a * b;\n', '      assert(a == 0 || c / a == b);\n', '      return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b > 0);\n', '      uint256 c = a / b;\n', '      return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      assert(b <= a);\n', '      return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure  returns (uint256) {\n', '      uint256 c = a + b;\n', '      assert(c >= a);\n', '      return c;\n', '  }\n', '}\n', '\n', '//*************** Ownable\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  function Ownable() public {\n', '      owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '      require(msg.sender == owner);\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner)public onlyOwner {\n', '      if (newOwner != address(0)) {\n', '        owner = newOwner;\n', '      }\n', '  }\n', '\n', '}\n', '\n', '//************* ERC20\n', '\n', 'contract ERC20 {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who)public constant returns (uint256);\n', '  function transfer(address to, uint256 value)public returns (bool);\n', '  function transferFrom(address from, address to, uint256 value)public returns (bool);\n', '  function allowance(address owner, address spender)public constant returns (uint256);\n', '  function approve(address spender, uint256 value)public returns (bool);\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event PreICOTokenPushed(address indexed buyer, uint256 amount);\n', '  event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);  \n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '//*************HeroChain Token\n', '\n', 'contract HeroChainToken is ERC20,Ownable {\n', '\tusing SafeMath for uint256;\n', '\n', '\t// Token Info.\n', '\tstring public name;\n', '\tstring public symbol;\n', '\n', '\tuint8 public constant decimals = 18;\n', '\n', '\taddress[] private walletArr;\n', '\tuint walletIdx = 0;\n', '\n', '\tmapping (address => uint256) public balanceOf;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '\n', '\tevent TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);\n', '\tevent FundTransfer(address fundWallet, uint256 amount);\n', '\n', '\tfunction HeroChainToken( \n', '\t\tuint256 _totalSupply, \n', '\t\tstring _name, \n', '\t\tstring _symbol,  \n', '\t\taddress _wallet1\n', '\n', '\t) public {  \t\t\n', '\n', '\trequire(_wallet1 != 0x0);\n', '\t\t\n', '\tbalanceOf[msg.sender] = _totalSupply;\n', '\ttotalSupply = _totalSupply;\n', '\tname = _name;\n', '\tsymbol = _symbol;\n', '\t\n', '\twalletArr.push(_wallet1);\n', '\t\n', '\t}\n', '\n', '\tfunction balanceOf(address _who)public constant returns (uint256 balance) {\n', '\t    return balanceOf[_who];\n', '\t}\n', '\n', '\tfunction _transferFrom(address _from, address _to, uint256 _value)  internal {\n', '\t    require(_to != 0x0);\n', '\t    require(balanceOf[_from] >= _value);\n', '\t    require(balanceOf[_to] + _value >= balanceOf[_to]);\n', '\n', '\t    balanceOf[_from] = balanceOf[_from].sub(_value);\n', '\t    balanceOf[_to] = balanceOf[_to].add(_value);\n', '\n', '\t    Transfer(_from, _to, _value);\n', '\t}\n', '\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool){\t    \n', '\t    _transferFrom(msg.sender,_to,_value);\n', '\t    return true;\n', '\t}\n', '\n', '\tfunction push(address _buyer, uint256 _amount) public onlyOwner {\n', '\t    uint256 val=_amount*(10**18);\n', '\t    _transferFrom(msg.sender,_buyer,val);\n', '\t    PreICOTokenPushed(_buyer, val);\n', '\t}\n', '\n', '\tfunction ()public payable {\n', '\t    _tokenPurchase( msg.value);\n', '\t}\n', '\n', '\tfunction _tokenPurchase( uint256 _value) internal {\n', '\t   \n', '\t    require(_value >= 0.1 ether);\n', '\n', '\t    address wallet = walletArr[walletIdx];\n', '\t    walletIdx = (walletIdx+1) % walletArr.length;\n', '\n', '\t    wallet.transfer(msg.value);\n', '\t    FundTransfer(wallet, msg.value);\n', '\t}\n', '\n', '\tfunction supply()  internal constant  returns (uint256) {\n', '\t    return balanceOf[owner];\n', '\t}\n', '\n', '\tfunction getCurrentTimestamp() internal view returns (uint256){\n', '\t    return now;\n', '\t}\n', '\n', '\tfunction allowance(address _owner, address _spender)public constant returns (uint256 remaining) {\n', '\t    return allowed[_owner][_spender];\n', '\t}\n', '\n', '\tfunction approve(address _spender, uint256 _value)public returns (bool) {\n', '\t    require((_value == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '\t    allowed[msg.sender][_spender] = _value;\n', '\t    Approval(msg.sender, _spender, _value);\n', '\t    return true;\n', '\t}\n', '\t\n', '\tfunction transferFrom(address _from, address _to, uint256 _value)public returns (bool) {\n', '\t    var _allowance = allowed[_from][msg.sender];\n', '\n', '\t    require (_value <= _allowance);\n', '\t\t\n', '\t     _transferFrom(_from,_to,_value);\n', '\n', '\t    allowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t    Transfer(_from, _to, _value);\n', '\t    return true;\n', '\t  }\n', '\t\n', '}']