['pragma solidity ^0.4.18;\n', '\n', '\n', 'contract HelpMeTokenInterface{\n', '    function thankYou( address _a )  public returns(bool);\n', '    function owner()  public returns(address);\n', '}\n', '\n', '\n', 'contract HelpMeTokenPart6 {\n', '    \n', '    string public name = ") AND THIS LETTER WILL BE LOST";\n', '    string public symbol = ") AND THIS LETTER WILL BE LOST";\n', '    uint256 public num = 6;\n', '    uint256 public totalSupply = 2100005 ether;\n', '    uint32 public constant decimals = 18;\n', '    \n', '    mapping(address => bool) thank_you;\n', '    bool public stop_it = false;\n', '    address constant helpMeTokenPart1 = 0xf6228fcD2A2FbcC29F629663689987bDcdbA5d13;\n', '    \n', '    modifier onlyPart1() {\n', '        require(msg.sender == helpMeTokenPart1);\n', '        _;\n', '    }\n', '    \n', '    event Transfer(address from, address to, uint tokens);\n', '    \n', '    function() public payable\n', '    {\n', '        require( msg.value > 0 );\n', '        HelpMeTokenInterface token = HelpMeTokenInterface (helpMeTokenPart1);\n', '        token.owner().transfer(msg.value);\n', '        token.thankYou( msg.sender );\n', '    }\n', '    \n', '    function stopIt() public onlyPart1 returns(bool)\n', '    {\n', '        stop_it = true;\n', '        return true;\n', '    }\n', '    \n', '    function thankYou(address _a) public onlyPart1 returns(bool)\n', '    {\n', '        thank_you[_a] = true;\n', '        emit Transfer(_a, address(this), num * 1 ether);\n', '        return true;\n', '    }\n', '    \n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        if( stop_it ) return 0;\n', '        else if( thank_you[_owner] == true ) return 0;\n', '        else return num  * 1 ether;\n', '        \n', '    }\n', '    \n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '        return true;\n', '    }\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        return true;\n', '    }\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return num;\n', '     }\n', '\n', '}']