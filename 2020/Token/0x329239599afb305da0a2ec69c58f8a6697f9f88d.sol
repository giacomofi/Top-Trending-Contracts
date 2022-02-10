['pragma solidity 0.6.10;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', 'contract YPoolDelegator {\n', '    address[] public _coins;\n', '    address[] public _underlying_coins;\n', '    uint256[] public _balances;\n', '    uint256 public A;\n', '    uint256 public fee;\n', '    uint256 public admin_fee;\n', '    uint256 constant max_admin_fee = 5 * 10 ** 9;\n', '    address public owner;\n', '    address token;\n', '    uint256 public admin_actions_deadline;\n', '    uint256 public transfer_ownership_deadline;\n', '    uint256 public future_A;\n', '    uint256 public future_fee;\n', '    uint256 public future_admin_fee;\n', '    address public future_owner;\n', '    \n', '    uint256 kill_deadline;\n', '    uint256 constant kill_deadline_dt = 2 * 30 * 86400;\n', '    bool is_killed;\n', '    \n', '    constructor(address[4] memory _coinsIn, address[4] memory _underlying_coinsIn, address _pool_token, uint256 _A, uint256 _fee) public {\n', '        for (uint i = 0; i < 4; i++) {\n', '            require(_coinsIn[i] != address(0));\n', '            require(_underlying_coinsIn[i] != address(0));\n', '            _balances.push(0);\n', '            _coins.push(_coinsIn[i]);\n', '            _underlying_coins.push(_underlying_coinsIn[i]);\n', '        }\n', '        A = _A;\n', '        fee = _fee;\n', '        admin_fee = 0;\n', '        owner = msg.sender;\n', '        kill_deadline = block.timestamp + kill_deadline_dt;\n', '        is_killed = false;\n', '        token = _pool_token;\n', '    }\n', '    \n', '    function balances(int128 i) public view returns (uint256) {\n', '        return _balances[uint256(i)];\n', '    }\n', '    \n', '    function coins(int128 i) public view returns (address) {\n', '        return _coins[uint256(i)];\n', '    }\n', '    \n', '    function underlying_coins(int128 i) public view returns (address) {\n', '        return _underlying_coins[uint256(i)];\n', '    }\n', '\n', '    fallback() external payable {\n', '        address _target = 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;\n', '\n', '        assembly {\n', '            let _calldataMemOffset := mload(0x40)\n', '            let _callDataSZ := calldatasize()\n', '            let _size := and(add(_callDataSZ, 0x1f), not(0x1f))\n', '            mstore(0x40, add(_calldataMemOffset, _size))\n', '            calldatacopy(_calldataMemOffset, 0x0, _callDataSZ)\n', '            let _retval := delegatecall(gas(), _target, _calldataMemOffset, _callDataSZ, 0, 0)\n', '            switch _retval\n', '            case 0 {\n', '                revert(0,0)\n', '            } default {\n', '                let _returndataMemoryOff := mload(0x40)\n', '                mstore(0x40, add(_returndataMemoryOff, returndatasize()))\n', '                returndatacopy(_returndataMemoryOff, 0x0, returndatasize())\n', '                return(_returndataMemoryOff, returndatasize())\n', '            }\n', '        }\n', '    }\n', '}']