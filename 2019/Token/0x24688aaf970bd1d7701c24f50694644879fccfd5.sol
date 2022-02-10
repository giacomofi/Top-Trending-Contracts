['pragma solidity ^0.5.9;\n', '\n', '\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() external view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == _owner, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) external onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '// File: contracts/commons/Wallet.sol\n', '\n', 'pragma solidity ^0.5.9;\n', '\n', '\n', '\n', 'contract Wallet is Ownable {\n', '    function execute(\n', '        address payable _to,\n', '        uint256 _value,\n', '        bytes calldata _data\n', '    ) external onlyOwner returns (bool, bytes memory) {\n', '        return _to.call.value(_value)(_data);\n', '    }\n', '}\n', '\n', 'interface NanoLoanEngine {\n', '    function transferFrom(address from, address to, uint256 index) external returns (bool);\n', '}\n', '\n', 'contract LoanPull is Ownable, Wallet {\n', '    event Pulling(address _engine, address _from, address _to, uint256 _ids);\n', '    event Pulled(uint256 _id, bool _success);\n', '\n', '    function pullLoans(\n', '        NanoLoanEngine _engine,\n', '        address _from,\n', '        address _to,\n', '        uint256[] calldata _ids\n', '    ) external onlyOwner {\n', '        uint256 len = _ids.length;\n', '\n', '        emit Pulling(address(_engine), _from, _to, len);\n', '\n', '        for (uint256 i = 0; i < len; i++) {\n', '            uint256 id = _ids[i];\n', '            bool success = _engine.transferFrom(_from, _to, id);\n', '            emit Pulled(id, success);\n', '        }\n', '    }\n', '}']