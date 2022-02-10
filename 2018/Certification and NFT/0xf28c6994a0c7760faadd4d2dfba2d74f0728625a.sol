['pragma solidity 0.4.23;\n', '\n', 'contract ERC20BasicInterface {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    function decimals() public view returns (uint8);\n', '    function name() public view returns (string);\n', '    function symbol() public view returns (string);\n', '    function totalSupply() public view returns (uint256 supply);\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '}\n', '\n', 'contract ERC20Interface is ERC20BasicInterface {\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '    function allowance(address _owner, address _spender) public view returns (uint256 remaining);\n', '}\n', '\n', '/**\n', ' * @title ERC20Pocket\n', ' *\n', ' * This contract keeps particular token for the single owner.\n', ' *\n', ' * Original purpose is to be able to separate your tokens into different pockets for dedicated purposes.\n', ' * Whenewer a withdrawal happen, it will be transparent that tokens were taken from a particular pocket.\n', ' *\n', ' * Contract emits purely informational events when transfers happen, for better visualisation on explorers.\n', ' */\n', 'contract OPEXairdrop is ERC20BasicInterface {\n', '    ERC20Interface public constant TOKEN = ERC20Interface(0x0b34a04b77Aa9bd2C07Ef365C05f7D0234C95630);\n', '    address public constant OWNER = 0xCba6eE74b7Ca65Bd0506cf21d62bDd7c71F86AD8;\n', '    string constant NAME = &#39;Optherium Airdrop Tokens&#39;;\n', '    string constant SYMBOL = &#39;OPEXairdrop&#39;;\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == OWNER, &#39;Access denied&#39;);\n', '        _;\n', '    }\n', '\n', '    function deposit(uint _value) public onlyOwner() returns(bool) {\n', '        require(TOKEN.transferFrom(OWNER, address(this), _value), &#39;Deposit failed&#39;);\n', '        emit Transfer(0x0, OWNER, _value);\n', '        return true;\n', '    }\n', '\n', '    function withdraw(address _to, uint _value) public onlyOwner() returns(bool) {\n', '        require(TOKEN.transfer(_to, _value), &#39;Withdrawal failed&#39;);\n', '        emit Transfer(OWNER, 0x0, _value);\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public view returns(uint) {\n', '        return TOKEN.balanceOf(address(this));\n', '    }\n', '\n', '    function balanceOf(address _holder) public view returns(uint) {\n', '        if (_holder == OWNER) {\n', '            return totalSupply();\n', '        }\n', '        return 0;\n', '    }\n', '\n', '    function decimals() public view returns(uint8) {\n', '        return TOKEN.decimals();\n', '    }\n', '\n', '    function name() public view returns(string) {\n', '        return NAME;\n', '    }\n', '\n', '    function symbol() public view returns(string) {\n', '        return SYMBOL;\n', '    }\n', '\n', '    function transfer(address _to, uint _value) public returns(bool) {\n', '        if (_to == address(this)) {\n', '            deposit(_value);\n', '        } else {\n', '            withdraw(_to, _value);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function recoverTokens(ERC20BasicInterface _token, address _to, uint _value) public onlyOwner() returns(bool) {\n', '        require(address(_token) != address(TOKEN), &#39;Can not recover this token&#39;);\n', '        return _token.transfer(_to, _value);\n', '    }\n', '}']