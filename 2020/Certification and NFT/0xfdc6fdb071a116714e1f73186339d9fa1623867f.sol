['/**\n', ' *Submitted for verification at Etherscan.io on 2021-02-24\n', '*/\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract TellorWrapper {\n', '    function balanceOf(address _user) external view returns (uint256);\n', '    function transfer(address _to, uint256 _amount) external returns (bool);\n', '    \n', '    function withdrawStake() external;\n', '    function getUintVar(bytes32 _data) public view returns (uint256);\n', '}\n', '\n', 'contract TellorC {\n', '    address private tellor = 0x0Ba45A8b5d5575935B8158a88C631E9F9C95a2e5;\n', '\n', '    bytes32 constant slotProgress = 0x6c505cb2db6644f57b42d87bd9407b0f66788b07d0617a2bc1356a0e69e66f9a; // keccak256("slotProgress")\n', '    address private owner;\n', '    address private miner;\n', '    \n', '    constructor () public {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function changeMiner(address _addr) external {\n', '        require(msg.sender == owner);\n', '        \n', '        miner = _addr;\n', '    }\n', '\n', '    function withdrawTrb(uint256 _amount) external {\n', '        require(msg.sender == owner);\n', '\n', '        TellorWrapper(tellor).transfer(msg.sender, _amount);\n', '    }\n', '\n', '    function withdrawEth(uint256 _amount) external {\n', '        require(msg.sender == owner);\n', '\n', '        msg.sender.transfer(_amount);\n', '    }\n', '\n', '    function depositStake() external {\n', '        require(msg.sender == owner);\n', '\n', '        TellorC(tellor).depositStake();\n', '    }\n', '\n', '    function requestStakingWithdraw() external {\n', '        require(msg.sender == owner);\n', '\n', '        TellorC(tellor).requestStakingWithdraw();\n', '    }\n', '\n', '    // Use finalize() if possible\n', '    function withdrawStake() external {\n', '        require(msg.sender == owner);\n', '\n', '        TellorC(tellor).withdrawStake();\n', '    }\n', '\n', '    function finalize() external {\n', '        require(msg.sender == owner);\n', '\n', '        TellorWrapper(tellor).withdrawStake();\n', '        uint256 _balance = TellorWrapper(tellor).balanceOf(address(this));\n', '        TellorWrapper(tellor).transfer(msg.sender, _balance);\n', '        selfdestruct(msg.sender);\n', '    }\n', '\n', '    function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external {\n', '        require(TellorWrapper(tellor).getUintVar(slotProgress) < 4 || gasleft() > 1000000, "X");\n', '        require(msg.sender == miner || msg.sender == owner, "Unauthorized");\n', '\n', '        TellorC(tellor).submitMiningSolution(_nonce, _requestId, _value);\n', '    }\n', '    \n', '    function() external {\n', '        require(msg.sender == address(0), "Not allowed"); // Dont allow actual calls, only views\n', '        \n', '        address addr = tellor;\n', '        bytes memory _calldata = msg.data;\n', '        assembly {\n', '            let result := call(not(0), addr, 0, add(_calldata, 0x20), mload(_calldata), 0, 0)\n', '            let size := returndatasize\n', '            let ptr := mload(0x40)\n', '            returndatacopy(ptr, 0, size)\n', '            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.\n', '            // if the call returned error data, forward it\n', '            switch result\n', '                case 0 {\n', '                    revert(ptr, size)\n', '                }\n', '                default {\n', '                    return(ptr, size)\n', '                }\n', '        }\n', '    }\n', '}']