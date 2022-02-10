['pragma solidity ^0.4.19;\n', '\n', 'contract Token {\n', '\n', '    function balanceOf(address _owner)  public constant returns (uint256 balance) {}\n', '    function transfer(address _to, uint256 _value) public  returns (bool success) {}\n', '    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success) {}\n', '    function approve(address _spender, uint256 _value)  public returns (bool success) {}\n', '    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining) {}\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '    event Changeethereallet(address indexed _etherwallet,address indexed _newwallet);\n', '}\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '  }\n', '\n', 'contract StandardToken is Token {\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '      //  if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        if (balances[msg.sender] >= _value && _value > 0) {\n', '            balances[msg.sender] -= _value;\n', '            balances[_to] += _value;\n', '            Transfer(msg.sender, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {\n', '        //?if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {\n', '            if (balances[_from] >= _value  && _value > 0) {\n', '            balances[_to] += _value;\n', '            balances[_from] -= _value;\n', '            allowed[_from][msg.sender] -= _value;\n', '            Transfer(_from, _to, _value);\n', '            return true;\n', '        } else { return false; }\n', '    }\n', '\n', '    function balanceOf(address _owner) constant public returns (uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '      return allowed[_owner][_spender];\n', '    }\n', '\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '    uint256 public totalSupply;\n', '}\n', '\n', 'contract ZelaaCoin is StandardToken,Ownable {\n', '\n', ' \n', '    string public name;           \n', '    uint256 public decimals;      \n', '    string public symbol;         \n', '\n', '    address owner;\n', '    address tokenwallet;//= 0xbB502303929607bf3b5D8B968066bf8dd275720d;\n', '    address etherwallet;//= 0xdBfC66799F2f381264C4CaaE9178680E4cCE80B5;\n', '\n', '    function changeEtherWallet(address _newwallet) onlyOwner() public returns (address) {\n', '    \n', '    etherwallet = _newwallet ;\n', '    Changeethereallet(etherwallet,_newwallet);\n', '    return ( _newwallet) ;\n', '}\n', '\n', '    function ZelaaCoin() public {\n', '        owner=msg.sender;\n', '        tokenwallet= 0xbB502303929607bf3b5D8B968066bf8dd275720d;\n', '        etherwallet= 0xdBfC66799F2f381264C4CaaE9178680E4cCE80B5;\n', '        name = "ZelaaCoin";\n', '        decimals = 18;            \n', '        symbol = "ZLC";          \n', '        totalSupply = 100000000 * (10**decimals);        \n', '        balances[tokenwallet] = totalSupply;               // Give the creator all initial tokens \n', '    }\n', '\n', '\n', '    function getOwner() constant public returns(address){\n', '        return(owner);\n', '    }\n', '    \n', '    \n', '}\n', '    \n', 'contract sendETHandtransferTokens is ZelaaCoin {\n', '    \n', '        mapping(address => uint256) balances;\n', '    \n', '        uint256 public totalETH;\n', '        event FundTransfer(address user, uint amount, bool isContribution);\n', '\n', '\n', '       function () payable public {\n', '        uint amount = msg.value;\n', '        totalETH += amount;\n', '        etherwallet.transfer(amount); \n', '        FundTransfer(msg.sender, amount, true);\n', '    }\n', '    \n', '}']