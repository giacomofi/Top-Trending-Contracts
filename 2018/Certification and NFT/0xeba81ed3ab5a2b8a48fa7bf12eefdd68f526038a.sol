['pragma solidity ^0.4.18;\n', '\n', '// Bravo Coin (BRV)\n', '// Pre ICO Sale Contract\n', '// 1 ETH = 10000 BRV\n', '\n', '// -----------------\n', '\n', '// Ownable\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;}\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner); _; } }\n', '\n', '// PreICOSale\n', '\n', 'contract PreICOSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  ERC20 public token;\n', '  address public wallet;\n', '  uint256 public rate;\n', '  uint256 public weiRaised;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function PreICOSale (uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token; }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);}\n', '\n', '\n', '  function buyTokens(address _beneficiary) public payable {\n', '    require(msg.value >= 0.01 ether);\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    _processPurchase(_beneficiary, tokens);\n', '    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount); }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0); }\n', '\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }\n', '\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount); }\n', '\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount); }\n', '\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }\n', '\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate); }\n', '\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value); }\n', '   \n', '// Used to end the Presale\n', '\n', '  function TokenDestructible() public payable { }\n', '  function destroy(address[] tokens) onlyOwner public {\n', '\n', '// Transfer tokens to owner\n', '\n', '    for (uint256 i = 0; i < tokens.length; i++) {\n', '      ERC20Basic token = ERC20Basic(tokens[i]);\n', '      uint256 balance = token.balanceOf(this);\n', '      token.transfer(owner, balance);} \n', '    selfdestruct(owner); }}\n', '    \n', '  \n', '  \n', '// SafeMath    \n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0; }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c; }\n', '    \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c; }\n', '    \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b; }\n', '    \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;}}\n', '    \n', '// ERC20Basic    \n', '    \n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);}\n', '\n', '// ERC20\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);}']
['pragma solidity ^0.4.18;\n', '\n', '// Bravo Coin (BRV)\n', '// Pre ICO Sale Contract\n', '// 1 ETH = 10000 BRV\n', '\n', '// -----------------\n', '\n', '// Ownable\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  function Ownable() public {\n', '    owner = msg.sender;}\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner); _; } }\n', '\n', '// PreICOSale\n', '\n', 'contract PreICOSale is Ownable {\n', '  using SafeMath for uint256;\n', '\n', '  ERC20 public token;\n', '  address public wallet;\n', '  uint256 public rate;\n', '  uint256 public weiRaised;\n', '\n', '  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);\n', '\n', '  function PreICOSale (uint256 _rate, address _wallet, ERC20 _token) public {\n', '    require(_rate > 0);\n', '    require(_wallet != address(0));\n', '    require(_token != address(0));\n', '\n', '    rate = _rate;\n', '    wallet = _wallet;\n', '    token = _token; }\n', '\n', '  function () external payable {\n', '    buyTokens(msg.sender);}\n', '\n', '\n', '  function buyTokens(address _beneficiary) public payable {\n', '    require(msg.value >= 0.01 ether);\n', '    uint256 weiAmount = msg.value;\n', '    _preValidatePurchase(_beneficiary, weiAmount);\n', '    uint256 tokens = _getTokenAmount(weiAmount);\n', '    weiRaised = weiRaised.add(weiAmount);\n', '    _processPurchase(_beneficiary, tokens);\n', '    TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);\n', '    _updatePurchasingState(_beneficiary, weiAmount);\n', '    _forwardFunds();\n', '    _postValidatePurchase(_beneficiary, weiAmount); }\n', '\n', '  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {\n', '    require(_beneficiary != address(0));\n', '    require(_weiAmount != 0); }\n', '\n', '  function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }\n', '\n', '  function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {\n', '    token.transfer(_beneficiary, _tokenAmount); }\n', '\n', '  function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {\n', '    _deliverTokens(_beneficiary, _tokenAmount); }\n', '\n', '  function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }\n', '\n', '  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {\n', '    return _weiAmount.mul(rate); }\n', '\n', '  function _forwardFunds() internal {\n', '    wallet.transfer(msg.value); }\n', '   \n', '// Used to end the Presale\n', '\n', '  function TokenDestructible() public payable { }\n', '  function destroy(address[] tokens) onlyOwner public {\n', '\n', '// Transfer tokens to owner\n', '\n', '    for (uint256 i = 0; i < tokens.length; i++) {\n', '      ERC20Basic token = ERC20Basic(tokens[i]);\n', '      uint256 balance = token.balanceOf(this);\n', '      token.transfer(owner, balance);} \n', '    selfdestruct(owner); }}\n', '    \n', '  \n', '  \n', '// SafeMath    \n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0; }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c; }\n', '    \n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a / b;\n', '    return c; }\n', '    \n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b; }\n', '    \n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;}}\n', '    \n', '// ERC20Basic    \n', '    \n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);}\n', '\n', '// ERC20\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);}']
