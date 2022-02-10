['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-26\n', '*/\n', '\n', 'pragma solidity ^0.4.17;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', ' \n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', ' \n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', ' \n', '        return c;\n', '    }\n', ' \n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', ' \n', 'contract ERC20Interface {\n', '      function totalSupply() public  constant returns (uint totalSupply); //返回总金额\n', '      function balanceOf(address _owner) public constant returns (uint balance);//返回地址账户金额总数\n', '      function transfer(address _to, uint _value) public returns (bool success);//转账\n', '      function transferFrom(address _from, address _to, uint _value) public returns (bool success);//授权之后才能转账\n', '      function approve(address _spender, uint _value) public returns (bool success);//账户授权\n', '      function allowance(address _owner, address _spender) public constant returns (uint remaining);//授权金额\n', '      event Transfer(address indexed _from, address indexed _to, uint _value);\n', '      event Approval(address indexed _owner, address indexed _spender, uint _value);\n', '    }\n', ' \n', ' \n', ' \n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '    address public owner;\n', ' \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', ' \n', '/**\n', '* @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '* account.\n', '*/\n', '    function Ownable() public {\n', '        owner = msg.sender;\n', '    }\n', ' \n', ' \n', '/**\n', '* @dev Throws if called by any account other than the owner.\n', '*/\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', ' \n', ' \n', '/**\n', '* @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '* @param newOwner The address to transfer ownership to.\n', '*/\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', ' \n', '}\n', ' \n', 'contract USDToken is ERC20Interface,Ownable {\n', '    string public symbol; //代币符号\n', '    string public name;   //代币名称\n', '    \n', '    uint8 public decimal; //精确小数位\n', '    uint public _totalSupply; //总的发行代币数\n', '    \n', '    mapping(address => uint) balances; //地址映射金额数\n', '    mapping(address =>mapping(address =>uint)) allowed; //授权地址使用金额绑定\n', '    \n', ' \n', '    //引入safemath 类库\n', '    using SafeMath for uint;\n', '    \n', '    //构造函数\n', '    //function LOPOToken() public{\n', '    function USDToken() public{\n', '        symbol = "USDT";\n', '        name = "USD Token";\n', '        decimal = 18;\n', '        _totalSupply = 88543211000000000000000000;\n', '        balances[msg.sender]=_totalSupply;//给发送者地址所有金额\n', '        Transfer(address(0),msg.sender,_totalSupply );//转账事件\n', '    }\n', ' \n', '    function totalSupply() public constant returns (uint totalSupply){\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public constant returns (uint balance){\n', '        return balances[_owner];\n', '    }\n', ' \n', '    function transfer(address _to, uint _value) public returns (bool success){\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender,_to,_value);\n', '        return true;\n', '    }\n', ' \n', '    function approve(address _spender, uint _value) public returns (bool success){\n', '        allowed[msg.sender][_spender]=_value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address _owner, address _spender) public constant returns (uint remaining){\n', '        return allowed[_owner][_spender];\n', '    }\n', ' \n', '    function transferFrom(address _from, address _to, uint _value) public returns (bool success){\n', '        allowed[_from][_to] = allowed[_from][_to].sub(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(_from,_to,_value);\n', '        return true;\n', '    }\n', ' \n', '    //匿名函数回滚 禁止转账给me\n', '    function() payable {\n', '        revert();\n', '    }\n', '\n', ' \n', '    //转账给任何合约\n', '    function transferAnyERC20Token(address tokenaddress,uint tokens) public onlyOwner returns(bool success){\n', '        ERC20Interface(tokenaddress).transfer(msg.sender,tokens);\n', '    }\n', '}']