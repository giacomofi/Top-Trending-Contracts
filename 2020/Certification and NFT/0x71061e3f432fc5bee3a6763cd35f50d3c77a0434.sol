['pragma solidity 0.5.16;\n', '\n', '\n', 'contract IERC20WithCheckpointing {\n', '    function balanceOf(address _owner) public view returns (uint256);\n', '    function balanceOfAt(address _owner, uint256 _blockNumber) public view returns (uint256);\n', '\n', '    function totalSupply() public view returns (uint256);\n', '    function totalSupplyAt(uint256 _blockNumber) public view returns (uint256);\n', '}\n', '\n', 'contract IIncentivisedVotingLockup is IERC20WithCheckpointing {\n', '\n', '    function getLastUserPoint(address _addr) external view returns(int128 bias, int128 slope, uint256 ts);\n', '    function createLock(uint256 _value, uint256 _unlockTime) external;\n', '    function withdraw() external;\n', '    function increaseLockAmount(uint256 _value) external;\n', '    function increaseLockLength(uint256 _unlockTime) external;\n', '    function eject(address _user) external;\n', '    function expireContract() external;\n', '\n', '    function claimReward() public;\n', '    function earned(address _account) public view returns (uint256);\n', '}\n', '\n', 'contract Ejector {\n', '\n', '    IIncentivisedVotingLockup public votingLockup;\n', '\n', '    constructor(IIncentivisedVotingLockup _votingLockup) public {\n', '        votingLockup = _votingLockup;\n', '    }\n', '\n', '    function ejectMany(address[] calldata _users) external {\n', '        uint count = _users.length;\n', '        for(uint i = 0; i < count; i++){\n', '            votingLockup.eject(_users[i]);\n', '        }\n', '    }\n', '\n', '}']