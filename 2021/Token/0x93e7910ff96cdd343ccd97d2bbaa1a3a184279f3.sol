['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-25\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract MoonToken {\n', '    string  public name = "BLUE MOON";\n', '    string  public symbol = "MOON";\n', '    uint256 public totalSupply;  \n', '    uint8   public decimals = 18;\n', '\taddress public owner;\n', '\n', '    event Transfer(\n', '        address indexed _from,\n', '        address indexed _to,\n', '        uint256 _value\n', '    );\n', '\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _value\n', '    );\n', '\n', '    mapping(address => uint256) public balances;\n', '    mapping(address => mapping(address => uint256)) public allowed;\n', '\n', '\tmapping(address => bool) public hasMinted;\n', '\n', '    // --- Math ---\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '    \n', '    constructor() public {\n', '        balances[msg.sender] = 100000000000000000000000000000;  // 100b tokens\n', '        totalSupply = balances[msg.sender];\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        require(balances[msg.sender] >= _value);\n', '        balances[msg.sender] =sub( balances[msg.sender], _value );\n', '        balances[_to] = add( balances[_to], _value );\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = sub( balances[_from], _value );\n', '        balances[_to] = add( balances[_to], _value) ;\n', '        allowed[_from][msg.sender] = sub(allowed[_from][msg.sender] , _value );\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    // free tokens for first timer\n', '    function mint(address receiver, uint amount) public {\n', '        require(!hasMinted[receiver], "ONCE IN A BLUE MOON!");\n', '        \n', '        uint256 reward = 10000000000000000000000; // 10000 tokens\n', '        balances[receiver] = add(balances[receiver], reward); //10 tokens\n', '        totalSupply = add(totalSupply, reward);\n', '\t\thasMinted[receiver] = true;       \n', '    }    \n', '}']