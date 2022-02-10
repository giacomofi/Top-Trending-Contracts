['/*\n', '███╗   ███╗ ██████╗ ██╗      \n', '████╗ ████║██╔═══██╗██║    \n', '██╔████╔██║██║   ██║██║    \n', '██║╚██╔╝██║██║   ██║██║    \n', '██║ ╚═╝ ██║╚██████╔╝███████╗\n', '███████╗ █████╗ ██████╗                              \n', '╚══███╔╝██╔══██╗██╔══██╗                             \n', '  ███╔╝ ███████║██████╔╝                             \n', ' ███╔╝  ██╔══██║██╔═══╝                              \n', '███████╗██║  ██║██║\n', 'DEAR MSG.SENDER(S):\n', '/ MolZap (⚡👹⚡) is a project in beta.\n', '// Please audit and use at your own risk.\n', '/// STEAL THIS C0D3SL4W \n', '//// presented by LexDAO LLC\n', '*/\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', 'pragma solidity 0.7.4;\n', '\n', 'interface IERC20ApproveTransfer { // brief interface for erc20 token tx\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '}\n', '\n', 'interface IMoloch { // brief interface for txs to moloch dao\n', '    function cancelProposal(uint256 proposalId) external;\n', '    \n', '    function submitProposal(\n', '        address applicant,\n', '        uint256 sharesRequested,\n', '        uint256 lootRequested,\n', '        uint256 tributeOffered,\n', '        address tributeToken,\n', '        uint256 paymentRequested,\n', '        address paymentToken,\n', '        string calldata details\n', '    ) external returns (uint256);\n', '    \n', '    function withdrawBalance(address token, uint256 amount) external;\n', '}\n', '\n', 'library SafeMath { // arithmetic wrapper for unit under/overflow check\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '    \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract MolZap {\n', '    using SafeMath for uint256;\n', '    \n', '    address public manager; // manages moloch zap settings\n', '    address public moloch; // parent moloch for zap proposals \n', '    address public wETH; // ether token wrapper contract reference for proposals\n', '    uint256 public zapRate; // rate to convert ether into zap proposal shares (e.g., `10` will submit proposal for 10 shares per 1 ETH sent)\n', '    string public ZAP_DETAILS; // general zap proposal details \n', '\n', '    mapping(uint256 => Zap) public zaps; // proposalId => Zap\n', '    \n', '    struct Zap {\n', '        address proposer;\n', '        uint256 zapAmount;\n', '    }\n', '\n', '    event ProposeZap(address indexed proposer, uint256 proposalId);\n', '    event WithdrawZapProposal(address indexed proposer, uint256 proposalId);\n', '    event UpdateMolZap(address indexed manager, address indexed moloch, address indexed wETH, uint256 zapRate, string ZAP_DETAILS);\n', '\n', '    constructor(\n', '        address _manager, \n', '        address _moloch, \n', '        address _wETH, \n', '        uint256 _zapRate, \n', '        string memory _ZAP_DETAILS\n', '    ) {\n', '        manager = _manager;\n', '        moloch = _moloch;\n', '        wETH = _wETH;\n', '        zapRate = _zapRate;\n', '        ZAP_DETAILS = _ZAP_DETAILS;\n', '        IERC20ApproveTransfer(wETH).approve(moloch, uint256(-1));\n', '    }\n', '    \n', '    receive() external payable { // msg.sender ether submits share proposal to moloch per zap rate (adjusted for wei conversion to normal moloch amounts)\n', '        (bool success, ) = wETH.call{value: msg.value}("");\n', '        require(success, "MolZap::transfer failed");\n', '        \n', '        uint256 proposalId = IMoloch(moloch).submitProposal(\n', '            msg.sender,\n', '            msg.value.mul(zapRate).div(10**18),\n', '            0,\n', '            msg.value,\n', '            wETH,\n', '            0,\n', '            wETH,\n', '            ZAP_DETAILS\n', '        );\n', '        \n', '        zaps[proposalId] = Zap(msg.sender, msg.value);\n', '\n', '        emit ProposeZap(msg.sender, proposalId);\n', '    }\n', '    \n', '    function cancelZapProposal(uint256 proposalId) external { // zap proposer can cancel zap & withdraw proposal funds \n', '        Zap storage zap = zaps[proposalId];\n', '        require(msg.sender == zap.proposer, "MolZap::!proposer");\n', '        uint256 zapAmount = zap.zapAmount;\n', '        \n', '        IMoloch(moloch).cancelProposal(proposalId); // cancel zap proposal in parent moloch\n', '        IMoloch(moloch).withdrawBalance(wETH, zapAmount); // withdraw zap funds from moloch\n', '        IERC20ApproveTransfer(wETH).transfer(msg.sender, zapAmount); // redirect funds to zap proposer\n', '        \n', '        emit WithdrawZapProposal(msg.sender, proposalId);\n', '    }\n', '    \n', '    function drawZapProposal(uint256 proposalId) external { // if proposal fails, withdraw back to proposer\n', '        Zap storage zap = zaps[proposalId];\n', '        require(msg.sender == zap.proposer, "MolZap::!proposer");\n', '        uint256 zapAmount = zap.zapAmount;\n', '        \n', '        IMoloch(moloch).withdrawBalance(wETH, zapAmount); // withdraw zap funds from parent moloch\n', '        IERC20ApproveTransfer(wETH).transfer(msg.sender, zapAmount); // redirect funds to zap proposer\n', '        \n', '        emit WithdrawZapProposal(msg.sender, proposalId);\n', '    }\n', '    \n', '    function updateMolZap( // manager (e.g., moloch via adminion) adjusts zap proposal settings\n', '        address _manager, \n', '        address _moloch, \n', '        address _wETH, \n', '        uint256 _zapRate, \n', '        string calldata _ZAP_DETAILS\n', '    ) external { \n', '        require(msg.sender == manager, "MolZap::!manager");\n', '       \n', '        manager = _manager;\n', '        moloch = _moloch;\n', '        wETH = _wETH;\n', '        zapRate = _zapRate;\n', '        ZAP_DETAILS = _ZAP_DETAILS;\n', '        \n', '        emit UpdateMolZap(_manager, _moloch, _wETH, _zapRate, _ZAP_DETAILS);\n', '    }\n', '}']