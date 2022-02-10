['pragma solidity ^0.4.24;\n', '\n', '\n', 'interface ERC20 {\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address tokenOwner) external view returns (uint balance);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint remaining);\n', '    function transfer(address to, uint tokens) external returns (bool success);\n', '    function approve(address spender, uint tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint tokens) external returns (bool success);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '    function add(uint a, uint b) internal pure returns (uint c) {\n', '        c = a + b;\n', '        require(c >= a, "Addition overflow");\n', '    }\n', '    function sub(uint a, uint b) internal pure returns (uint c) {\n', '        require(b <= a, "Subtraction overflow");\n', '        c = a - b;\n', '    }\n', '    function mul(uint a, uint b) internal pure returns (uint c) {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b, "Multiplication overflow");\n', '    }\n', '    function div(uint a, uint b) internal pure returns (uint c) {\n', '        require(b > 0, "The denominator is 0");\n', '        c = a / b;\n', '    }\n', '}\n', '\n', '\n', 'contract Transfer\n', '{\n', '    using SafeMath for uint;\n', '    address owner;\n', '    \n', '    event MultiTransfer(\n', '        address indexed _from,\n', '        uint indexed _value,\n', '        address _to,\n', '        uint _amount\n', '    );\n', '\n', '    event MultiERC20Transfer(\n', '        address indexed _from,\n', '        address _to,\n', '        uint _amount,\n', '        ERC20 _token\n', '    );\n', '    \n', '    constructor () public payable {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function multiTransfer(address[] _addresses, uint[] _amounts) public payable returns(bool) {\n', '        uint toReturn = msg.value;\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            _safeTransfer(_addresses[i], _amounts[i]);\n', '            toReturn = SafeMath.sub(toReturn, _amounts[i]);\n', '            emit MultiTransfer(msg.sender, msg.value, _addresses[i], _amounts[i]);\n', '        }\n', '        _safeTransfer(msg.sender, toReturn);\n', '        return true;\n', '    }\n', '\n', '    function multiERC20Transfer(ERC20 _token, address[] _addresses, uint[] _amounts) public payable {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            _safeERC20Transfer(_token, _addresses[i], _amounts[i]);\n', '            emit MultiERC20Transfer(\n', '                msg.sender,\n', '                _addresses[i],\n', '                _amounts[i],\n', '                _token\n', '            );\n', '        }\n', '    }\n', '\n', '    function _safeTransfer(address _to, uint _amount) internal {\n', '        require(_to != 0, "Receipt address can\'t be 0");\n', '        _to.transfer(_amount);\n', '    }\n', '\n', '    function _safeERC20Transfer(ERC20 _token, address _to, uint _amount) internal {\n', '        require(_to != 0, "Receipt address can\'t be 0");\n', '        require(_token.transferFrom(msg.sender, _to, _amount), "Sending a token failed");\n', '    }\n', '\n', '    function () public payable {\n', '        revert("Contract prohibits receiving funds");\n', '    }\n', '\n', '    function forwardTransaction( address destination, uint amount, uint gasLimit, bytes data) internal {\n', '        require(msg.sender == owner, "Not an administrator");\n', '        require(\n', '            destination.call.gas(\n', '                (gasLimit > 0) ? gasLimit : gasleft()\n', '            ).value(amount)(data), \n', '            "operation failed"\n', '        );\n', '    }\n', '}']