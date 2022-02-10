['// SPDX-License-Identifier: F-F-F-FIAT!!!\n', 'pragma solidity ^0.7.4;\n', '\n', 'import "./Address.sol";\n', 'import "./SafeERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./IERC20.sol";\n', 'import "./Fiat.sol";\n', 'import "./TokensRecoverable.sol";\n', '\n', '/* ROOTKIT:\n', '- Minting contract for initial supply of FIAT\n', '- To be Owned by the ROOT DAO multisig\n', '- This minter contract is for internal use only\n', '- Mint amount per ROOT should never be more than 50% of the current ROOT price\n', '- This Minter contracts will be phased out when more public minters are active\n', '- Other minter contracts will all be available to the public\n', '*/\n', '\n', 'contract InitialSupplyMinter is TokensRecoverable {\n', '    using Address for address;\n', '    using SafeERC20 for IERC20;\n', '    using SafeMath for uint256;\n', '\n', '    Fiat public immutable fiat;\n', '    IERC20 public immutable rootKit;\n', '\n', '    mapping(address => bool) public approvedMinters;\n', '    mapping(address => uint256) public collaterals; // Root\n', '    mapping(address => uint256) public debts; // Fiat   \n', '\n', '    uint256 public fiatPerRoot = 1000;\n', '\n', '    constructor(Fiat _fiat, IERC20 _rootKit) {\n', '        fiat = _fiat;\n', '        rootKit = _rootKit;\n', '    }\n', '\n', '    function updateFiatPerRoot(uint256 _fiatPerRoot) public ownerOnly() {\n', '        fiatPerRoot = _fiatPerRoot;\n', '    }\n', '\n', '    function setMinter(address minter, bool canMint) public ownerOnly() {\n', '        approvedMinters[minter] = canMint;\n', '    }\n', '\n', '    function depositCollateral(uint256 amount) public {\n', '        require(approvedMinters[msg.sender], "Not an approved minter");\n', '\n', '        rootKit.transferFrom(msg.sender, address(this), amount);\n', '        collaterals[msg.sender] += amount;\n', '    }\n', '\n', '    function mintFiat(uint256 amount) public {\n', '        require(approvedMinters[msg.sender], "Not an approved minter");\n', '        require(amount <= getAvailableToMint(msg.sender), "Not enought collateral to mint fiat");\n', '\n', '        fiat.mint(msg.sender, amount);\n', '        debts[msg.sender] += amount;\n', '    }\n', '\n', '    function repayDebt(address account, uint256 amount) public {\n', '        fiat.burn(msg.sender, amount);\n', '        debts[account] -= amount;\n', '    }\n', '\n', '    function withdrawCollateral(uint256 amount) public {\n', '        require(approvedMinters[msg.sender], "Not an approved minter");\n', '        require(getAvailableCollateralToWithdraw(msg.sender) >= amount, "Not enought collateral to withdraw");\n', '\n', '        rootKit.transfer(msg.sender, amount);\n', '        collaterals[msg.sender] -= amount;\n', '    }\n', '\n', '    function getAvailableToMint(address account) public view returns (uint256) {\n', '        return collaterals[account] * fiatPerRoot - debts[account];\n', '    }\n', '\n', '    function getAvailableCollateralToWithdraw(address account) public view returns (uint256) {\n', '        return collaterals[account] - debts[account].mul(1e18).div(fiatPerRoot).div(1e18);\n', '    }\n', '}']