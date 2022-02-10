['pragma solidity ^0.4.15;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable () public{\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '\n', 'contract ERC20 {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '\tuint256 public totalSupply;\n', '\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract Propthereum is Ownable, ERC20{\n', '    using SafeMath for uint256;\n', '\n', '    //ERC20\n', '    string public name = "Propthereum";\n', '    string public symbol = "PTC";\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    //ICO\n', '    //State values\n', '    uint256 public ethRaised;\n', '    \n', '    uint256[7] public saleStageStartDates = [1510934400,1511136000,1511222400,1511827200,1512432000,1513036800,1513641600];\n', '\n', '    //The prices for each stage. The number of tokens a user will receive for 1ETH.\n', '    uint16[6] public tokens = [1800,1650,1500,1450,1425,1400];\n', '\n', '    // This creates an array with all balances\n', '    mapping (address => uint256) private balances;\n', '    mapping (address => mapping (address => uint256)) public allowed;\n', '\n', '    address public constant WITHDRAW_ADDRESS = 0x35528E0c694D3c3B3e164FFDcC1428c076B9467d;\n', '\n', '    function Propthereum() public {\n', '\t\towner = msg.sender;\n', '        decimals = 18;\n', '        totalSupply = 360000000 * 10**18;\n', '        balances[address(this)] = totalSupply;\n', '\t}\n', '\n', '    function balanceOf(address who) public constant returns (uint256) {\n', '        return balances[who];\n', '    }\n', '\n', '\tfunction transfer(address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_to != address(0));\n', '        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        Transfer(_from,_to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '\t\trequire(_spender != address(0));\n', '        require(allowed[msg.sender][_spender] == 0 || _amount == 0);\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '\t\trequire(_owner != address(0));\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    //ICO\n', '    function getPreSaleStart() public constant returns (uint256) {\n', '        return saleStageStartDates[0];\n', '    }\n', '\n', '    function getPreSaleEnd() public constant returns (uint256) {\n', '        return saleStageStartDates[1];\n', '    }\n', '\n', '    function getSaleStart() public constant returns (uint256) {\n', '        return saleStageStartDates[1];\n', '    }\n', '\n', '    function getSaleEnd() public constant returns (uint256) {\n', '        return saleStageStartDates[6];\n', '    }\n', '\n', '    function inSalePeriod() public constant returns (bool) {\n', '        return (now >= getSaleStart() && now <= getSaleEnd());\n', '    }\n', '\n', '    function inpreSalePeriod() public constant returns (bool) {\n', '        return (now >= getPreSaleStart() && now <= getPreSaleEnd());\n', '    }\n', '\n', '    function() public payable {\n', '        buyTokens();\n', '    }\n', '\n', '    function buyTokens() public payable {\n', '        require(msg.value > 0);\n', '        require(inSalePeriod() == true || inpreSalePeriod()== true );\n', '        require(msg.sender != address(0));\n', '\n', '        uint index = getStage();\n', '        uint256 amount = tokens[index];\n', '        amount = amount.mul(msg.value);\n', '        balances[msg.sender] = balances[msg.sender].add(amount);\n', '        uint256 total_amt =  amount.add((amount.mul(30)).div(100));\n', '        balances[owner] = balances[owner].add((amount.mul(30)).div(100));\n', '        balances[address(this)] = balances[address(this)].sub(total_amt);\n', '        ethRaised = ethRaised.add(msg.value);\n', '    }\n', '\n', '    function transferEth() public onlyOwner {\n', '        WITHDRAW_ADDRESS.transfer(this.balance);\n', '    }\n', '\n', '   function burn() public onlyOwner {\n', '        require (now > getSaleEnd());\n', '        //Burn outstanding\n', '        totalSupply = totalSupply.sub(balances[address(this)]);\n', '        balances[address(this)] = 0;\n', '    }\n', '\n', '  function getStage() public constant returns (uint256) {\n', '        for (uint8 i = 1; i < saleStageStartDates.length; i++) {\n', '            if (now < saleStageStartDates[i]) {\n', '                return i -1;\n', '            }\n', '        }\n', '\n', '        return saleStageStartDates.length - 1;\n', '    }\n', '\n', '    event TokenPurchase(address indexed _purchaser, uint256 _value, uint256 _amount);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Withdraw(address indexed _owner, uint256 _value);\n', '}']