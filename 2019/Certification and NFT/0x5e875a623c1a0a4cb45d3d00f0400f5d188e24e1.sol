['pragma solidity ^0.5.8;\n', '\n', 'contract Ownable\n', '{\n', '    bool private stopped;\n', '    address private _owner;\n', '    address private _master;\n', '\n', '    event Stopped();\n', '    event Started();\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    event MasterRoleTransferred(address indexed previousMaster, address indexed newMaster);\n', '\n', '    constructor () internal\n', '    {\n', '        stopped = false;\n', '        _owner = msg.sender;\n', '        _master = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '        emit MasterRoleTransferred(address(0), _master);\n', '    }\n', '\n', '    function owner() public view returns (address)\n', '    {\n', '        return _owner;\n', '    }\n', '\n', '    function master() public view returns (address)\n', '    {\n', '        return _master;\n', '    }\n', '\n', '    modifier onlyOwner()\n', '    {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    modifier onlyMaster()\n', '    {\n', '        require(isMaster() || isOwner());\n', '        _;\n', '    }\n', '\n', '    modifier onlyWhenNotStopped()\n', '    {\n', '        require(!isStopped());\n', '        _;\n', '    }\n', '\n', '    function isOwner() public view returns (bool)\n', '    {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    function isMaster() public view returns (bool)\n', '    {\n', '        return msg.sender == _master;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) external onlyOwner\n', '    {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    function transferMasterRole(address newMaster) external onlyOwner\n', '    {\n', '        _transferMasterRole(newMaster);\n', '    }\n', '\n', '    function isStopped() public view returns (bool)\n', '    {\n', '        return stopped;\n', '    }\n', '\n', '    function stop() public onlyOwner\n', '    {\n', '        _stop();\n', '    }\n', '\n', '    function start() public onlyOwner\n', '    {\n', '        _start();\n', '    }\n', '\n', '    function _transferOwnership(address newOwner) internal\n', '    {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '\n', '    function _transferMasterRole(address newMaster) internal\n', '    {\n', '        require(newMaster != address(0));\n', '        emit MasterRoleTransferred(_master, newMaster);\n', '        _master = newMaster;\n', '    }\n', '\n', '    function _stop() internal\n', '    {\n', '        emit Stopped();\n', '        stopped = true;\n', '    }\n', '\n', '    function _start() internal\n', '    {\n', '        emit Started();\n', '        stopped = false;\n', '    }\n', '}\n', '\n', 'contract ChannelWallet is Ownable\n', '{\n', '    mapping(string => address) private addressMap;\n', '\n', '    event SetAddress(string channelId, address _address);\n', '    event UpdateAddress(string from, string to);\n', '    event DeleteAddress(string account);\n', '\n', '    function version() external pure returns(string memory)\n', '    {\n', "        return '0.0.1';\n", '    }\n', '\n', '    function getAddress(string calldata channelId) external view returns (address)\n', '    {\n', '        return addressMap[channelId];\n', '    }\n', '\n', '    function setAddress(string calldata channelId, address _address) external onlyMaster onlyWhenNotStopped\n', '    {\n', '        require(bytes(channelId).length > 0);\n', '\n', '        addressMap[channelId] = _address;\n', '\n', '        emit SetAddress(channelId, _address);\n', '    }\n', '\n', '    function updateChannel(string calldata from, string calldata to, address _address) external onlyMaster onlyWhenNotStopped\n', '    {\n', '        require(bytes(from).length > 0);\n', '        require(bytes(to).length > 0);\n', '        require(addressMap[to] == address(0));\n', '\n', '        addressMap[to] = _address;\n', '\n', '        addressMap[from] = address(0);\n', '\n', '        emit UpdateAddress(from, to);\n', '    }\n', '\n', '    function deleteChannel(string calldata channelId) external onlyMaster onlyWhenNotStopped\n', '    {\n', '        require(bytes(channelId).length > 0);\n', '\n', '        addressMap[channelId] = address(0);\n', '\n', '        emit DeleteAddress(channelId);\n', '    }\n', '}']