['pragma solidity ^0.4.21;\n', '\n', 'library SafeMath256 {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '          return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', '// github.com/ethereum/EIPs/issues/223\n', 'contract ERC223 {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '    uint256 public totalSupply;\n', '    mapping (address => uint256) public balanceOf;\n', '    function transfer(address _to, uint256 _value) public;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract FintechnicsPublic is ERC223 {\n', '    using SafeMath256 for uint256;\n', '\n', '    string public constant name = "Fintechnics Public";\n', '    string public constant symbol = "FINTP";\n', '    uint256 public constant decimals = 18;\n', '    uint256 public totalSupply = 150000000 * 10**decimals;\n', '    address public owner = address(0);\n', '    mapping (address => uint256) public balanceOf;\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function isContract(address _addr) internal view returns (bool is_contract) {\n', '        uint256 length;\n', '        assembly { length := extcodesize(_addr) }\n', '        return length > 0;\n', '    }\n', '\n', '    function mint(uint256 _value) public onlyOwner {\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);\n', '        totalSupply = totalSupply.add(_value);\n', '        emit Transfer(address(0), owner, _value);\n', '    }\n', '\n', '    function burn(uint256 _value) public onlyOwner {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        totalSupply = totalSupply.sub(_value);\n', '        emit Transfer(msg.sender, address(0), _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public {\n', '        require(!isContract(_to) && msg.sender != _to && balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '    }\n', '\n', '    function FintechnicsPublic() public {\n', '        owner = msg.sender;\n', '        balanceOf[owner] = totalSupply;\n', '        emit Transfer(address(0), owner, totalSupply);\n', '    }\n', '}']