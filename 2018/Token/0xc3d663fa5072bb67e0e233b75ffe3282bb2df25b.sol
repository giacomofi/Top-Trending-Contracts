['pragma solidity ^0.4.13;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public view returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract BoLuoPay is ERC20,Ownable{\n', '\tusing SafeMath for uint256;\n', '\n', '\tstring public name="BoLuoPay";\n', '\tstring public symbol="boluo";\n', '\tstring public constant version = "1.0";\n', '\tuint256 public constant decimals = 18;\n', '\t//总已经发行量\n', '\tuint256 public totalSupply;\n', '\t//已经空投量\n', '\tuint256 public airdropSupply;\n', '\t//已经直投量\n', '\tuint256 public directSellSupply;\n', '\tuint256 public directSellRate;\n', '\n', '\tuint256 public  MAX_SUPPLY;\n', '\n', '\t\n', '    mapping(address => uint256) balances;\n', '\tmapping (address => mapping (address => uint256)) allowed;\n', '    event Wasted(address to, uint256 value, uint256 date);\n', '\n', '\tfunction BoLuoPay(){\n', '\t\tname = "BoLuoPay";\n', '\t\tsymbol = "boluo";\n', '\t\ttotalSupply = 0;\n', '\t\tairdropSupply = 0;\n', '\t\tdirectSellSupply = 0;\n', '\t\tdirectSellRate = 9000;\n', '\t\tMAX_SUPPLY = 90000000000000000000000000;\n', '\t}\n', '\n', '\tmodifier notReachTotalSupply(uint256 _value,uint256 _rate){\n', '\t\tassert(MAX_SUPPLY>=totalSupply.add(_value.mul(_rate)));\n', '\t\t_;\n', '\t}\n', '\n', '\n', '\tfunction addIssue(uint256 _supply) external\n', '\t\tonlyOwner\n', '\t{\n', '\t\tMAX_SUPPLY = MAX_SUPPLY.add(_supply);\n', '\t}\n', '\n', '\t/**\n', '\t * 更新直投参数\n', '\t */\n', '\tfunction refreshDirectSellParameter(uint256 _directSellRate) external\n', '\t\tonlyOwner\n', '\t{\n', '\t\tdirectSellRate = _directSellRate;\n', '\t}\n', '\n', '\t//提取代币，用于代投\n', '    function withdrawCoinToOwner(uint256 _value) external\n', '\t\tonlyOwner\n', '\t{\n', '\t\tprocessFunding(msg.sender,_value,1);\n', '\t}\n', '\n', '\t//空投\n', '    function airdrop(address [] _holders,uint256 paySize) external\n', '    \tonlyOwner \n', '\t{\n', '        uint256 count = _holders.length;\n', '        assert(paySize.mul(count) <= balanceOf(msg.sender));\n', '        for (uint256 i = 0; i < count; i++) {\n', '            transfer(_holders [i], paySize);\n', '\t\t\tairdropSupply = airdropSupply.add(paySize);\n', '        }\n', '        Wasted(owner, airdropSupply, now);\n', '    }\n', '\n', '\t//直投\n', '\tfunction () payable external\n', '\t{\n', '\t\tprocessFunding(msg.sender,msg.value,directSellRate);\n', '\t\tuint256 amount = msg.value.mul(directSellRate);\n', '\t\tdirectSellSupply = directSellSupply.add(amount);\t\t\n', '\t}\n', '\n', '\n', '\t//代币分发函数，内部使用\n', '\tfunction processFunding(address receiver,uint256 _value,uint256 _rate) internal\n', '\t\tnotReachTotalSupply(_value,_rate)\n', '\t{\n', '\t\tuint256 amount=_value.mul(_rate);\n', '\t\ttotalSupply=totalSupply.add(amount);\n', '\t\tbalances[receiver] +=amount;\n', '\t\tTransfer(0x0, receiver, amount);\n', '\t}\n', '\n', '\t//提取直投eth\n', '\tfunction etherProceeds() external\n', '\t\tonlyOwner\n', '\t{\n', '\t\tif(!msg.sender.send(this.balance)) revert();\n', '\t}\n', '\n', '  \tfunction transfer(address _to, uint256 _value) public  returns (bool)\n', ' \t{\n', '\t\trequire(_to != address(0));\n', '\t\t// SafeMath.sub will throw if there is not enough balance.\n', '\t\tbalances[msg.sender] = balances[msg.sender].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tTransfer(msg.sender, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction balanceOf(address _owner) public constant returns (uint256 balance) \n', '  \t{\n', '\t\treturn balances[_owner];\n', '  \t}\n', '\n', '  \tfunction transferFrom(address _from, address _to, uint256 _value) public returns (bool) \n', '  \t{\n', '\t\trequire(_to != address(0));\n', '\t\tuint256 _allowance = allowed[_from][msg.sender];\n', '\n', '\t\tbalances[_from] = balances[_from].sub(_value);\n', '\t\tbalances[_to] = balances[_to].add(_value);\n', '\t\tallowed[_from][msg.sender] = _allowance.sub(_value);\n', '\t\tTransfer(_from, _to, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction approve(address _spender, uint256 _value) public returns (bool) \n', '  \t{\n', '\t\tallowed[msg.sender][_spender] = _value;\n', '\t\tApproval(msg.sender, _spender, _value);\n', '\t\treturn true;\n', '  \t}\n', '\n', '  \tfunction allowance(address _owner, address _spender) public constant returns (uint256 remaining) \n', '  \t{\n', '\t\treturn allowed[_owner][_spender];\n', '  \t}\n', '\n', '}']