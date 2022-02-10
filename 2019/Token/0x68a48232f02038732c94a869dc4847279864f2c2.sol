['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-09\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-04\n', '*/\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath for uint256\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath256 {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '}\n', '\n', 'contract F152{\n', '\n', '  using SafeMath256 for uint256;\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant decimalFactor = 10 ** uint256(decimals);\n', '\n', '    function batchTtransferEther(address[] _to,uint256[] _value) public payable {//批量转ETH #单地址指定金额\n', '        require(_to.length>0);\n', '\n', '        for(uint256 i=0;i<_to.length;i++)\n', '        {\n', '            _to[i].transfer(_value[i]);\n', '        }\n', '    }\n', '    \n', '    function batchTransferVoken(address from,address caddress,address[] _to,uint256[] value)public returns (bool){//批量转代币 #多指定金额\n', '        require(_to.length > 0);\n', '        bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));\n', '        for(uint256 i=0;i<_to.length;i++){\n', '            caddress.call(id,from,_to[i],value[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-04\n', '*/\n', '\n', 'pragma solidity ^0.4.25;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath for uint256\n', ' * @dev Unsigned math operations with safety checks that revert on error.\n', ' */\n', 'library SafeMath256 {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://eips.ethereum.org/EIPS/eip-20\n', ' */\n', 'interface IERC20{\n', '    function balanceOf(address owner) external view returns (uint256);\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '}\n', '\n', 'contract F152{\n', '\n', '  using SafeMath256 for uint256;\n', '  uint8 public constant decimals = 18;\n', '  uint256 public constant decimalFactor = 10 ** uint256(decimals);\n', '\n', '    function batchTtransferEther(address[] _to,uint256[] _value) public payable {//批量转ETH #单地址指定金额\n', '        require(_to.length>0);\n', '\n', '        for(uint256 i=0;i<_to.length;i++)\n', '        {\n', '            _to[i].transfer(_value[i]);\n', '        }\n', '    }\n', '    \n', '    function batchTransferVoken(address from,address caddress,address[] _to,uint256[] value)public returns (bool){//批量转代币 #多指定金额\n', '        require(_to.length > 0);\n', '        bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));\n', '        for(uint256 i=0;i<_to.length;i++){\n', '            caddress.call(id,from,_to[i],value[i]);\n', '        }\n', '        return true;\n', '    }\n', '\n', '}']
