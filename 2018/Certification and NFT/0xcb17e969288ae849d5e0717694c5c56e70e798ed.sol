['pragma solidity 0.4.24;\n', 'pragma experimental "v0.5.0";\n', '\n', '/*\n', '\n', '    Copyright 2018 dYdX Trading Inc.\n', '\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '\n', '*/\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/lib/GeneralERC20.sol\n', '\n', '/**\n', ' * @title GeneralERC20\n', ' * @author dYdX\n', ' *\n', ' * Interface for using ERC20 Tokens. We have to use a special interface to call ERC20 functions so\n', ' * that we dont automatically revert when calling non-compliant tokens that have no return value for\n', ' * transfer(), transferFrom(), or approve().\n', ' */\n', 'interface GeneralERC20 {\n', '    function totalSupply(\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function balanceOf(\n', '        address who\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function transfer(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '    function approve(\n', '        address spender,\n', '        uint256 value\n', '    )\n', '        external;\n', '}\n', '\n', '// File: contracts/lib/TokenInteract.sol\n', '\n', '/**\n', ' * @title TokenInteract\n', ' * @author dYdX\n', ' *\n', ' * This library contains functions for interacting with ERC20 tokens\n', ' */\n', 'library TokenInteract {\n', '    function balanceOf(\n', '        address token,\n', '        address owner\n', '    )\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return GeneralERC20(token).balanceOf(owner);\n', '    }\n', '\n', '    function allowance(\n', '        address token,\n', '        address owner,\n', '        address spender\n', '    )\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return GeneralERC20(token).allowance(owner, spender);\n', '    }\n', '\n', '    function approve(\n', '        address token,\n', '        address spender,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        GeneralERC20(token).approve(spender, amount);\n', '\n', '        require(\n', '            checkSuccess(),\n', '            "TokenInteract#approve: Approval failed"\n', '        );\n', '    }\n', '\n', '    function transfer(\n', '        address token,\n', '        address to,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        address from = address(this);\n', '        if (\n', '            amount == 0\n', '            || from == to\n', '        ) {\n', '            return;\n', '        }\n', '\n', '        GeneralERC20(token).transfer(to, amount);\n', '\n', '        require(\n', '            checkSuccess(),\n', '            "TokenInteract#transfer: Transfer failed"\n', '        );\n', '    }\n', '\n', '    function transferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        if (\n', '            amount == 0\n', '            || from == to\n', '        ) {\n', '            return;\n', '        }\n', '\n', '        GeneralERC20(token).transferFrom(from, to, amount);\n', '\n', '        require(\n', '            checkSuccess(),\n', '            "TokenInteract#transferFrom: TransferFrom failed"\n', '        );\n', '    }\n', '\n', '    // ============ Private Helper-Functions ============\n', '\n', '    /**\n', '     * Checks the return value of the previous function up to 32 bytes. Returns true if the previous\n', '     * function returned 0 bytes or 32 bytes that are not all-zero.\n', '     */\n', '    function checkSuccess(\n', '    )\n', '        private\n', '        pure\n', '        returns (bool)\n', '    {\n', '        uint256 returnValue = 0;\n', '\n', '        /* solium-disable-next-line security/no-inline-assembly */\n', '        assembly {\n', '            // check number of bytes returned from last function call\n', '            switch returndatasize\n', '\n', '            // no bytes returned: assume success\n', '            case 0x0 {\n', '                returnValue := 1\n', '            }\n', '\n', '            // 32 bytes returned: check if non-zero\n', '            case 0x20 {\n', '                // copy 32 bytes into scratch space\n', '                returndatacopy(0x0, 0x0, 0x20)\n', '\n', '                // load those bytes into returnValue\n', '                returnValue := mload(0x0)\n', '            }\n', '\n', '            // not sure what was returned: dont mark as success\n', '            default { }\n', '        }\n', '\n', '        return returnValue != 0;\n', '    }\n', '}\n', '\n', '// File: contracts/margin/interfaces/ExchangeWrapper.sol\n', '\n', '/**\n', ' * @title ExchangeWrapper\n', ' * @author dYdX\n', ' *\n', ' * Contract interface that Exchange Wrapper smart contracts must implement in order to interface\n', ' * with other smart contracts through a common interface.\n', ' */\n', 'interface ExchangeWrapper {\n', '\n', '    // ============ Public Functions ============\n', '\n', '    /**\n', '     * Exchange some amount of takerToken for makerToken.\n', '     *\n', '     * @param  tradeOriginator      Address of the initiator of the trade (however, this value\n', '     *                              cannot always be trusted as it is set at the discretion of the\n', '     *                              msg.sender)\n', '     * @param  receiver             Address to set allowance on once the trade has completed\n', '     * @param  makerToken           Address of makerToken, the token to receive\n', '     * @param  takerToken           Address of takerToken, the token to pay\n', '     * @param  requestedFillAmount  Amount of takerToken being paid\n', '     * @param  orderData            Arbitrary bytes data for any information to pass to the exchange\n', '     * @return                      The amount of makerToken received\n', '     */\n', '    function exchange(\n', '        address tradeOriginator,\n', '        address receiver,\n', '        address makerToken,\n', '        address takerToken,\n', '        uint256 requestedFillAmount,\n', '        bytes orderData\n', '    )\n', '        external\n', '        returns (uint256);\n', '\n', '    /**\n', '     * Get amount of takerToken required to buy a certain amount of makerToken for a given trade.\n', '     * Should match the takerToken amount used in exchangeForAmount. If the order cannot provide\n', '     * exactly desiredMakerToken, then it must return the price to buy the minimum amount greater\n', '     * than desiredMakerToken\n', '     *\n', '     * @param  makerToken         Address of makerToken, the token to receive\n', '     * @param  takerToken         Address of takerToken, the token to pay\n', '     * @param  desiredMakerToken  Amount of makerToken requested\n', '     * @param  orderData          Arbitrary bytes data for any information to pass to the exchange\n', '     * @return                    Amount of takerToken the needed to complete the transaction\n', '     */\n', '    function getExchangeCost(\n', '        address makerToken,\n', '        address takerToken,\n', '        uint256 desiredMakerToken,\n', '        bytes orderData\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '}\n', '\n', '// File: contracts/margin/external/exchangewrappers/OpenDirectlyExchangeWrapper.sol\n', '\n', '/**\n', ' * @title OpenDirectlyExchangeWrapper\n', ' * @author dYdX\n', ' *\n', ' * dYdX ExchangeWrapper to open a position by borrowing the owedToken instead of atomically selling\n', ' * it. This requires the trader to put up the entire collateral themselves.\n', ' */\n', 'contract OpenDirectlyExchangeWrapper is\n', '    ExchangeWrapper\n', '{\n', '    using SafeMath for uint256;\n', '    using TokenInteract for address;\n', '\n', '    // ============ Margin-Only Functions ============\n', '\n', '    function exchange(\n', '        address tradeOriginator,\n', '        address /* receiver */,\n', '        address /* makerToken */,\n', '        address takerToken,\n', '        uint256 requestedFillAmount,\n', '        bytes /* orderData */\n', '    )\n', '        external\n', '        returns (uint256)\n', '    {\n', '        require(\n', '            requestedFillAmount <= takerToken.balanceOf(address(this)),\n', '            "OpenDirectlyExchangeWrapper#exchange: Requested fill amount larger than tokens held"\n', '        );\n', '\n', '        TokenInteract.transfer(takerToken, tradeOriginator, requestedFillAmount);\n', '\n', '        return 0;\n', '    }\n', '\n', '    // ============ Public Constant Functions ============\n', '\n', '    function getExchangeCost(\n', '        address /* makerToken */,\n', '        address /* takerToken */,\n', '        uint256 desiredMakerToken,\n', '        bytes /* orderData */\n', '    )\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(\n', '            desiredMakerToken == 0,\n', '            "OpenDirectlyExchangeWrapper#getExchangeCost: DesiredMakerToken must be zero"\n', '        );\n', '\n', '        return 0;\n', '    }\n', '}']