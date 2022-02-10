['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'import "./SafeMath.sol";\n', 'import "./IUniswapV2Factory.sol";\n', 'import "./OwnableUpgradeSafe.sol";\n', 'import "./IERC20.sol";\n', '\n', 'contract XAUTransferHandler is OwnableUpgradeSafe {\n', '\n', '    using SafeMath for uint256;\n', '    address tokenUniswapPairXAU;\n', '    address[] public trackedPairs;\n', '    uint16 public feePercentX100;\n', '    bool public transfersPaused;\n', '    mapping (address => bool) public noFeeList;\n', '    mapping (address => bool) public isPair;\n', '\n', '    event NewTransfersPaused(bool oldTransfersPaused, bool newTransfersPaused);    \n', '    event NewFeePercentX100(uint256 oldFeePercentX100, uint256 newFeePercentX100);\n', '\n', '    function initialize(\n', '        address _tokenUniswapPairXAU,\n', '        address _xauVault,\n', '        uint16 _feePercentX100\n', '    ) public initializer {\n', '        tokenUniswapPairXAU = _tokenUniswapPairXAU;\n', '        OwnableUpgradeSafe.__Ownable_init();\n', '        feePercentX100 = _feePercentX100;\n', '        transfersPaused = true;\n', '        _editNoFeeList(_xauVault, true);\n', '        _addPairToTrack(tokenUniswapPairXAU);\n', '    }\n', '\n', '    function addPairToTrack(address pair) onlyOwner public {\n', '        _addPairToTrack(pair);\n', '    }\n', '\n', '    function setNewTokenUniswap(address _tokenUniswapPairXAU) public onlyOwner {\n', '        tokenUniswapPairXAU = _tokenUniswapPairXAU;\n', '        _addPairToTrack(tokenUniswapPairXAU);\n', '    }\n', '\n', '    function _addPairToTrack(address pair) internal {\n', '\n', '        uint256 length = trackedPairs.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            require(trackedPairs[i] != pair, "Pair already tracked");\n', '        }\n', '        // we sync\n', '        sync(pair); \n', '        // we add to array so we can loop over it\n', '        trackedPairs.push(pair);\n', '        // we add pair to no fee sender list\n', '        _editNoFeeList(pair, true);\n', '        // we add it to pair mapping to lookups\n', '        isPair[pair] = true;\n', '\n', '    }\n', '\n', '\n', '    // CORE token is pausable \n', '    function setTransfersPaused(bool _transfersPaused) public onlyOwner {\n', '        bool oldTransfersPaused = transfersPaused;\n', '        transfersPaused = _transfersPaused;\n', '\n', '        // Sync all tracked pairs\n', '        uint256 length = trackedPairs.length;\n', '        for (uint256 i = 0; i < length; i++) {\n', '            sync(trackedPairs[i]);\n', '        }\n', '\n', '        emit NewTransfersPaused(oldTransfersPaused, _transfersPaused);    \n', '    }\n', '\n', '    function setFeePercentX100(uint16 _feePercentX100) public onlyOwner {\n', "        require(_feePercentX100 <= 1000, 'Fee clamped at 10%');\n", '        uint256 oldFeePercentX100 = feePercentX100;\n', '        feePercentX100 = _feePercentX100;\n', '        emit NewFeePercentX100(oldFeePercentX100, _feePercentX100);\n', '    }\n', '\n', '    function editNoFeeList(address _address, bool noFee) public onlyOwner {\n', '        _editNoFeeList(_address, noFee);\n', '    }\n', '    function _editNoFeeList(address _address, bool noFee) internal{\n', '        noFeeList[_address] = noFee;\n', '    }\n', '\n', '    // Old sync for backwards compatibility - syncs xautokenEthPair\n', '    function sync() public returns (bool lastIsMint, bool lpTokenBurn) {\n', '        (lastIsMint, lpTokenBurn) = sync(tokenUniswapPairXAU);\n', '    }\n', '\n', '    mapping(address => uint256) private lpSupplyOfPair;\n', '\n', '    function sync(address pair) public returns (bool lastIsMint, bool lpTokenBurn) {\n', '        uint256 _LPSupplyOfPairNow = IERC20(pair).totalSupply();\n', '\n', '        lpTokenBurn = lpSupplyOfPair[pair] > _LPSupplyOfPairNow;\n', '        lpSupplyOfPair[pair] = _LPSupplyOfPairNow;\n', '\n', '        lastIsMint = false;\n', '    }\n', '\n', '    function handleTransfer\n', '        (address sender, \n', '        address recipient, \n', '        uint256 amount\n', '    ) public {\n', '    }\n', '\n', '    function calculateAmountsAfterFee(        \n', '        address sender, \n', '        address recipient, \n', '        uint256 amount\n', '    ) public returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) {\n', '        require(transfersPaused == false, "XAU TransferHandler: Transfers Paused");\n', '\n', '        if (isPair[recipient]) {\n', '            sync(recipient);\n', '        }\n', '\n', '        if (!isPair[recipient] && !isPair[sender])\n', '            sync();\n', '\n', '        if (noFeeList[sender]) {\n', '            transferToFeeDistributorAmount = 0;\n', '            transferToAmount = amount;\n', '        } \n', '        else {\n', '            // console.log("Normal fee transfer");\n', '            transferToFeeDistributorAmount = amount.mul(feePercentX100).div(10000);\n', '            transferToAmount = amount.sub(transferToFeeDistributorAmount);\n', '        }\n', '    }\n', '\n', '}']