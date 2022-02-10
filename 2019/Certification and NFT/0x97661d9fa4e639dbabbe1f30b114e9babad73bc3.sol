['pragma solidity ^0.5.2;\n', '\n', '// ----------------------------------------------------------------------------\n', '// Owned contract\n', '// ----------------------------------------------------------------------------\n', 'contract Owned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '}\n', '\n', '// ----------------------------------------------------------------------------\n', '// 奖池记录合约\n', '// ----------------------------------------------------------------------------\n', 'contract IMCPool is Owned{\n', '\n', '    // 奖池记录添加日志\n', '    event PoolRecordAdd(bytes32 _chainId, bytes32 _hash, uint _depth, string _data, string _fileFormat, uint _stripLen);\n', '\n', '    // Token奖池统计记录\n', '    struct RecordInfo {\n', '        bytes32 chainId; // 上链ID\n', '        bytes32 hash; // hash值\n', '        uint depth; // 层级\n', '        string data; // 竞价数据\n', '        string fileFormat; // 上链存证的文件格式\n', '        uint stripLen; // 上链存证的文件分区\n', '    }\n', '\n', '    // 执行者地址\n', '    address public executorAddress;\n', '    \n', '    // 奖此记录\n', '    mapping(bytes32 => RecordInfo) public poolRecord;\n', '    \n', '    constructor() public{\n', '        // 初始化合约执行者\n', '        executorAddress = msg.sender;\n', '    }\n', '    \n', '    /**\n', '     * 修改executorAddress，只有owner能够修改\n', '     * @param _addr address 地址\n', '     */\n', '    function modifyExecutorAddr(address _addr) public onlyOwner {\n', '        executorAddress = _addr;\n', '    }\n', '    \n', '     \n', '    /**\n', '     * 奖池记录添加\n', '     * @param _chainId bytes32 上链ID\n', '     * @param _hash bytes32 hash值\n', '     * @param _depth uint 上链阶段:1 加密上链，2结果上链\n', '     * @param _data string 竞价数据\n', '     * @param _fileFormat string 上链存证的文件格式\n', '     * @param _stripLen uint 上链存证的文件分区\n', '     * @return success 添加成功\n', '     */\n', '    function poolRecordAdd(bytes32 _chainId, bytes32 _hash, uint _depth, string memory _data, string memory _fileFormat, uint _stripLen) public returns (bool) {\n', '        // 调用者需和Owner设置的执行者地址一致\n', '        require(msg.sender == executorAddress);\n', '        // 防止重复记录\n', '        require(poolRecord[_chainId].chainId != _chainId);\n', '\n', '        // 记录解锁信息\n', '        poolRecord[_chainId] = RecordInfo(_chainId, _hash, _depth, _data, _fileFormat, _stripLen);\n', '\n', '        // 解锁日志记录\n', '        emit PoolRecordAdd(_chainId, _hash, _depth, _data, _fileFormat, _stripLen);\n', '        \n', '        return true;\n', '        \n', '    }\n', '\n', '}']