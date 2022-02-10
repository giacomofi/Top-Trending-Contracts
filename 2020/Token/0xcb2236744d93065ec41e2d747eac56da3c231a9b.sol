['pragma solidity >= 0.4.24 < 0.6.0;\n', '\n', '/**\n', ' * @title DCK Token\n', ' */\n', '\n', '/**\n', ' * @title ERC20 Standard Interface\n', ' */\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address who) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title DAU implementation\n', ' */\n', 'contract DCK is IERC20 {\n', '    string public name = "Doctor Cell K";\n', '    string public symbol = "DCK";\n', '    uint8 public decimals = 18;\n', '    \n', '    uint256 companyAmount;\n', '\n', '    uint256 _totalSupply;\n', '    mapping(address => uint256) balances;\n', '\n', '    // Addresses\n', '    address public owner;\n', '    address public company;\n', '\n', '    modifier isOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '    \n', '    constructor() public {\n', '        owner = msg.sender;\n', '\n', '        company = 0xaD3Cb6933A14888dCfB5DDAf623396877e198AEe;\n', '\n', '        companyAmount  = toWei(1000000000);\n', '        _totalSupply   = toWei(1000000000);  //1,000,000,000\n', '\n', '        require(_totalSupply == companyAmount );\n', '        \n', '        balances[owner] = _totalSupply;\n', '\n', '        emit Transfer(address(0), owner, balances[owner]);\n', '        \n', '        transfer(company, companyAmount);\n', '\n', '        require(balances[owner] == 0);\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address who) public view returns (uint256) {\n', '        return balances[who];\n', '    }\n', '    \n', '    function transfer(address to, uint256 value) public returns (bool success) {\n', '        require(msg.sender != to);\n', '        require(to != owner);\n', '        require(value > 0);\n', '        \n', '        require( balances[msg.sender] >= value );\n', '        require( balances[to] + value >= balances[to] );    // prevent overflow\n', '\n', '\n', '        balances[msg.sender] -= value;\n', '        balances[to] += value;\n', '\n', '        emit Transfer(msg.sender, to, value);\n', '        return true;\n', '    }\n', '    \n', '    function burnCoins(uint256 value) public {\n', '        require(balances[msg.sender] >= value);\n', '        require(_totalSupply >= value);\n', '        \n', '        balances[msg.sender] -= value;\n', '        _totalSupply -= value;\n', '\n', '        emit Transfer(msg.sender, address(0), value);\n', '    }\n', '\n', '    function toWei(uint256 value) private view returns (uint256) {\n', '        return value * (10 ** uint256(decimals));\n', '    }\n', '}']