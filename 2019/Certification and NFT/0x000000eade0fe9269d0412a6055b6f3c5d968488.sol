['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/utilities/UpgradeHelper.sol\n', '\n', 'contract OldTrueUSDInterface {\n', '    function delegateToNewContract(address _newContract) public;\n', '    function claimOwnership() public;\n', '    function balances() public returns(address);\n', '    function allowances() public returns(address);\n', '    function totalSupply() public returns(uint);\n', '    function transferOwnership(address _newOwner) external;\n', '}\n', 'contract NewTrueUSDInterface {\n', '    function setTotalSupply(uint _totalSupply) public;\n', '    function transferOwnership(address _newOwner) public;\n', '    function claimOwnership() public;\n', '}\n', '\n', 'contract TokenControllerInterface {\n', '    function claimOwnership() external;\n', '    function transferChild(address _child, address _newOwner) external;\n', '    function requestReclaimContract(address _child) external;\n', '    function issueClaimOwnership(address _child) external;\n', '    function setTrueUSD(address _newTusd) external;\n', '    function setTusdRegistry(address _Registry) external;\n', '    function claimStorageForProxy(address _delegate,\n', '        address _balanceSheet,\n', '        address _alowanceSheet) external;\n', '    function setGlobalPause(address _globalPause) external;\n', '    function transferOwnership(address _newOwner) external;\n', '    function owner() external returns(address);\n', '}\n', '\n', '/**\n', ' */\n', 'contract UpgradeHelper {\n', '    OldTrueUSDInterface public constant oldTrueUSD = OldTrueUSDInterface(0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E);\n', '    NewTrueUSDInterface public constant newTrueUSD = NewTrueUSDInterface(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    TokenControllerInterface public constant tokenController = TokenControllerInterface(0x0000000000075EfBeE23fe2de1bd0b7690883cc9);\n', '    address public constant registry = address(0x0000000000013949F288172bD7E36837bDdC7211);\n', '    address public constant globalPause = address(0x0000000000027f6D87be8Ade118d9ee56767d993);\n', '\n', '    function upgrade() public {\n', '        // TokenController should have end owner as it&#39;s pending owner at the end\n', '        address endOwner = tokenController.owner();\n', '\n', '        // Helper contract becomes the owner of controller, and both TUSD contracts\n', '        tokenController.claimOwnership();\n', '        newTrueUSD.claimOwnership();\n', '\n', '        // Initialize TrueUSD totalSupply\n', '        newTrueUSD.setTotalSupply(oldTrueUSD.totalSupply());\n', '\n', '        // Claim storage contract from oldTrueUSD\n', '        address balanceSheetAddress = oldTrueUSD.balances();\n', '        address allowanceSheetAddress = oldTrueUSD.allowances();\n', '        tokenController.requestReclaimContract(balanceSheetAddress);\n', '        tokenController.requestReclaimContract(allowanceSheetAddress);\n', '\n', '        // Transfer storage contract to controller then transfer it to NewTrueUSD\n', '        tokenController.issueClaimOwnership(balanceSheetAddress);\n', '        tokenController.issueClaimOwnership(allowanceSheetAddress);\n', '        tokenController.transferChild(balanceSheetAddress, newTrueUSD);\n', '        tokenController.transferChild(allowanceSheetAddress, newTrueUSD);\n', '        \n', '        newTrueUSD.transferOwnership(tokenController);\n', '        tokenController.issueClaimOwnership(newTrueUSD);\n', '        tokenController.setTrueUSD(newTrueUSD);\n', '        tokenController.claimStorageForProxy(newTrueUSD, balanceSheetAddress, allowanceSheetAddress);\n', '\n', '        // Configure TrueUSD\n', '        tokenController.setTusdRegistry(registry);\n', '        tokenController.setGlobalPause(globalPause);\n', '\n', '        // Point oldTrueUSD delegation to NewTrueUSD\n', '        tokenController.transferChild(oldTrueUSD, address(this));\n', '        oldTrueUSD.claimOwnership();\n', '        oldTrueUSD.delegateToNewContract(newTrueUSD);\n', '        \n', '        // Controller owns both old and new TrueUSD\n', '        oldTrueUSD.transferOwnership(tokenController);\n', '        tokenController.issueClaimOwnership(oldTrueUSD);\n', '        tokenController.transferOwnership(endOwner);\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/utilities/UpgradeHelper.sol\n', '\n', 'contract OldTrueUSDInterface {\n', '    function delegateToNewContract(address _newContract) public;\n', '    function claimOwnership() public;\n', '    function balances() public returns(address);\n', '    function allowances() public returns(address);\n', '    function totalSupply() public returns(uint);\n', '    function transferOwnership(address _newOwner) external;\n', '}\n', 'contract NewTrueUSDInterface {\n', '    function setTotalSupply(uint _totalSupply) public;\n', '    function transferOwnership(address _newOwner) public;\n', '    function claimOwnership() public;\n', '}\n', '\n', 'contract TokenControllerInterface {\n', '    function claimOwnership() external;\n', '    function transferChild(address _child, address _newOwner) external;\n', '    function requestReclaimContract(address _child) external;\n', '    function issueClaimOwnership(address _child) external;\n', '    function setTrueUSD(address _newTusd) external;\n', '    function setTusdRegistry(address _Registry) external;\n', '    function claimStorageForProxy(address _delegate,\n', '        address _balanceSheet,\n', '        address _alowanceSheet) external;\n', '    function setGlobalPause(address _globalPause) external;\n', '    function transferOwnership(address _newOwner) external;\n', '    function owner() external returns(address);\n', '}\n', '\n', '/**\n', ' */\n', 'contract UpgradeHelper {\n', '    OldTrueUSDInterface public constant oldTrueUSD = OldTrueUSDInterface(0x8dd5fbCe2F6a956C3022bA3663759011Dd51e73E);\n', '    NewTrueUSDInterface public constant newTrueUSD = NewTrueUSDInterface(0x0000000000085d4780B73119b644AE5ecd22b376);\n', '    TokenControllerInterface public constant tokenController = TokenControllerInterface(0x0000000000075EfBeE23fe2de1bd0b7690883cc9);\n', '    address public constant registry = address(0x0000000000013949F288172bD7E36837bDdC7211);\n', '    address public constant globalPause = address(0x0000000000027f6D87be8Ade118d9ee56767d993);\n', '\n', '    function upgrade() public {\n', "        // TokenController should have end owner as it's pending owner at the end\n", '        address endOwner = tokenController.owner();\n', '\n', '        // Helper contract becomes the owner of controller, and both TUSD contracts\n', '        tokenController.claimOwnership();\n', '        newTrueUSD.claimOwnership();\n', '\n', '        // Initialize TrueUSD totalSupply\n', '        newTrueUSD.setTotalSupply(oldTrueUSD.totalSupply());\n', '\n', '        // Claim storage contract from oldTrueUSD\n', '        address balanceSheetAddress = oldTrueUSD.balances();\n', '        address allowanceSheetAddress = oldTrueUSD.allowances();\n', '        tokenController.requestReclaimContract(balanceSheetAddress);\n', '        tokenController.requestReclaimContract(allowanceSheetAddress);\n', '\n', '        // Transfer storage contract to controller then transfer it to NewTrueUSD\n', '        tokenController.issueClaimOwnership(balanceSheetAddress);\n', '        tokenController.issueClaimOwnership(allowanceSheetAddress);\n', '        tokenController.transferChild(balanceSheetAddress, newTrueUSD);\n', '        tokenController.transferChild(allowanceSheetAddress, newTrueUSD);\n', '        \n', '        newTrueUSD.transferOwnership(tokenController);\n', '        tokenController.issueClaimOwnership(newTrueUSD);\n', '        tokenController.setTrueUSD(newTrueUSD);\n', '        tokenController.claimStorageForProxy(newTrueUSD, balanceSheetAddress, allowanceSheetAddress);\n', '\n', '        // Configure TrueUSD\n', '        tokenController.setTusdRegistry(registry);\n', '        tokenController.setGlobalPause(globalPause);\n', '\n', '        // Point oldTrueUSD delegation to NewTrueUSD\n', '        tokenController.transferChild(oldTrueUSD, address(this));\n', '        oldTrueUSD.claimOwnership();\n', '        oldTrueUSD.delegateToNewContract(newTrueUSD);\n', '        \n', '        // Controller owns both old and new TrueUSD\n', '        oldTrueUSD.transferOwnership(tokenController);\n', '        tokenController.issueClaimOwnership(oldTrueUSD);\n', '        tokenController.transferOwnership(endOwner);\n', '    }\n', '}']
