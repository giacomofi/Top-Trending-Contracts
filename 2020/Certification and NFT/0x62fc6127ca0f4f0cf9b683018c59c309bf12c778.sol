['// File: contracts/interfaces/ISynthetix.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface ISynthetix {\n', '\n', '    function exchangeOnBehalfWithTracking(\n', '        address exchangeForAddress,\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey,\n', '        address originator,\n', '        bytes32 trackingCode\n', '    ) external returns (uint amountReceived);\n', '\n', '}\n', '\n', '// File: @emilianobonassi/referral/SimpleReferral.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', 'contract SimpleReferral {\n', '\n', '    bool internal _justReferred;\n', '\n', '    mapping (address => address) public referrerForUser;\n', '\n', '\n', '    event NewReferral(address indexed referrer, address indexed user);\n', '\n', '\n', '    modifier referral(address user, address referrer) {\n', '        if (referrer != address(0) && !_hasReferrer(user)) {\n', '\n', '            referrerForUser[user] = referrer;\n', '            emit NewReferral(referrer, user);\n', '\n', '            _justReferred = true;\n', '            _;\n', '            _justReferred = false;\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '\n', '    function _hasReferrer(address user) internal view returns (bool) {\n', '        return referrerForUser[user] != address(0);\n', '    }\n', '}\n', '\n', '// File: @emilianobonassi/gas-saver/ChiGasSaver.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'contract IFreeFromUpTo {\n', '    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);\n', '}\n', '\n', 'contract ChiGasSaver {\n', '\n', '    modifier saveGas(address payable sponsor) {\n', '        uint256 gasStart = gasleft();\n', '        _;\n', '        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;\n', '\n', '        IFreeFromUpTo chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);\n', '        chi.freeFromUpTo(sponsor, (gasSpent + 14154) / 41947);\n', '    }\n', '}\n', '\n', '// File: contracts/SNXLinkTradeSaverV1.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', 'contract SNXLinkTradeSaverV1 is SimpleReferral, ChiGasSaver {\n', '    // SNX addresses\n', '    ISynthetix public constant Synthetix = ISynthetix(0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F);\n', '\n', '    // Partner program\n', '    bytes32 public constant trackingCode = 0x534e582e4c494e4b000000000000000000000000000000000000000000000000;\n', '\n', '    // Custom referral initiative\n', '    address public constant originator = 0x59846C1F45C67FA757438EC1B67bdd72BBe483b7;\n', '\n', '\n', '    function exchange(\n', '        bytes32 sourceCurrencyKey,\n', '        uint sourceAmount,\n', '        bytes32 destinationCurrencyKey,\n', '        address referrer\n', '    )\n', '    external\n', '    saveGas(msg.sender)\n', '    referral(msg.sender, referrer)\n', '    returns (uint amountReceived) {\n', '        return Synthetix.exchangeOnBehalfWithTracking(\n', '            msg.sender,\n', '            sourceCurrencyKey,\n', '            sourceAmount,\n', '            destinationCurrencyKey,\n', '            originator,\n', '            trackingCode\n', '        );\n', '    }\n', '}']