['pragma solidity ^0.4.21;\n', '\n', '// It makes multiple ERC20 (even ERC223) transaction in one.\n', '// Need to deposit before spread\n', '// Transfer to this contract is available as deposit\n', 'contract Airdroper {\n', '    mapping (address => mapping (address => uint)) balances;\n', '\n', '    constructor() public {}\n', '\n', '    function subtr(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function addit(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function tokenFallback(address _from, uint _amount, bytes _data) public returns (bool) {\n', '        balances[msg.sender][_from] = addit(balances[msg.sender][_from], _amount);\n', '        if (_data.length != 0) {\n', '            require(address(this).call(_data));\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function deposit(address _token, uint _amount) public returns (bool) {\n', '        // 0x23b872dd is function signature of `transferFrom(address,address,uint256)`\n', '        require(_token.call(0x23b872dd, msg.sender, this, _amount));\n', '        balances[_token][msg.sender] = addit(balances[_token][msg.sender], _amount);\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _token, address _user) public view returns (uint) {\n', '        return balances[_token][_user];\n', '    }\n', '\n', '    function spread(address _token, address[] _addresses, uint[] _amounts) public returns (bool) {\n', '        uint l = _addresses.length;\n', '        for (uint i = 0; i < l; i++) {\n', '            require(balances[_token][tx.origin] >= _amounts[i]);\n', '            // 0xa9059cbb is function signature of `transfer(address,uint256)`\n', '            require(_token.call(0xa9059cbb, _addresses[i], _amounts[i]));\n', '            balances[_token][tx.origin] = subtr(balances[_token][tx.origin], _amounts[i]);\n', '        }\n', '        return true;\n', '    }\n', '}']