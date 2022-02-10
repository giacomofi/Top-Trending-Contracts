['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-02\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.8.3;\n', 'interface IERC20 {\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '}\n', 'contract Staking {\n', '    address public owner;\n', '    IERC20 public TKN;\n', '    \n', '    uint256[] public periods = [30 days, 90 days, 150 days];\n', '    uint256[] public rates = [106, 121, 140];\n', '    uint256 public limit = 20000000000000000000000000;\n', '    uint256 public finish_timestamp = 1633046400; // 00:00 1 Oct 2021 UTC\n', '    \n', '    struct Stake {\n', '        uint8 class;\n', '        uint8 cycle;\n', '        uint256 initialAmount;\n', '        uint256 finalAmount;\n', '        uint256 timestamp;\n', '    }\n', '    \n', '    mapping(address => Stake) public stakeOf;\n', '    \n', '    event Staked(address sender, uint8 class, uint256 amount, uint256 finalAmount);\n', '    event Prolonged(address sender, uint8 class, uint8 cycle, uint256 newAmount, uint256 newFinalAmount);\n', '    event Unstaked(address sender, uint8 class, uint8 cycle, uint256 amount);\n', '    \n', '    function stake(uint8 _class, uint256 _amount) public {\n', '        require(_class < 3 && _amount >= 10000000000000000000); // data valid\n', '        require(stakeOf[msg.sender].cycle == 0); // not staking currently\n', '        require(finish_timestamp > block.timestamp + periods[_class]); // not staking in the end of program\n', '        uint256 _finalAmount = _amount * rates[_class] / 100;\n', '        limit -= _finalAmount - _amount;\n', '        require(TKN.transferFrom(msg.sender, address(this), _amount));\n', '        stakeOf[msg.sender] = Stake(_class, 1, _amount, _finalAmount, block.timestamp);\n', '        emit Staked(msg.sender, _class, _amount, _finalAmount);\n', '    }\n', '    \n', '    function prolong() public {\n', '        Stake storage _s = stakeOf[msg.sender];\n', '        require(_s.cycle > 0); // staking currently\n', '        require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished\n', '        require(finish_timestamp > block.timestamp + periods[_s.class]); // not prolonging in the end of program\n', '        uint256 _newFinalAmount = _s.finalAmount * rates[_s.class] / 100;\n', '        limit -= _newFinalAmount - _s.finalAmount;\n', '        _s.timestamp = block.timestamp;\n', '        _s.cycle++;\n', '        emit Prolonged(msg.sender, _s.class, _s.cycle, _s.finalAmount, _newFinalAmount);\n', '        _s.finalAmount = _newFinalAmount;\n', '    }\n', '\n', '    function unstake() public {\n', '        Stake storage _s = stakeOf[msg.sender];\n', '        require(_s.cycle > 0); // staking currently\n', '        require(block.timestamp >= _s.timestamp + periods[_s.class]); // staking period finished\n', '        require(TKN.transfer(msg.sender, _s.finalAmount));\n', '        emit Unstaked(msg.sender, _s.class, _s.cycle, _s.finalAmount);\n', '        delete stakeOf[msg.sender];\n', '    }\n', '    \n', '    function transferOwnership(address _owner) public {\n', '        require(msg.sender == owner);\n', '        owner = _owner;\n', '    }\n', '    \n', '    function drain(address _recipient) public {\n', '        require(msg.sender == owner);\n', '        require(block.timestamp > finish_timestamp); // after 1st Oct\n', '        require(TKN.transfer(_recipient, limit));\n', '        limit = 0;\n', '    }\n', '    \n', '    function drainFull(address _recipient) public {\n', '        require(msg.sender == owner);\n', '        require(block.timestamp > finish_timestamp + 31 days); // After 1st Nov\n', '        uint256 _amount = TKN.balanceOf(address(this));\n', '        require(TKN.transfer(_recipient, _amount));\n', '        limit = 0;\n', '    }\n', '    \n', '    constructor(IERC20 _TKN) {\n', '        owner = msg.sender;\n', '        TKN = _TKN;\n', '    }\n', '}']