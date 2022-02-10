['/*\n', ' *      ##########################################\n', ' *      ##########################################\n', ' *      ###                                    ###\n', ' *      ###          &#119823;&#119845;&#119834;&#119858; & &#119830;&#119842;&#119847; &#119812;&#119853;&#119841;&#119838;&#119851;          ###\n', ' *      ###                 at                 ###\n', ' *      ###          &#119812;&#119827;&#119815;&#119812;&#119825;&#119808;&#119813;&#119813;&#119819;&#119812;.&#119810;&#119822;&#119820;          ###\n', ' *      ###                                    ###\n', ' *      ##########################################\n', ' *      ##########################################\n', ' *\n', ' *      Welcome to the temporary &#119812;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838; &#119811;&#119842;&#119852;&#119835;&#119854;&#119851;&#119852;&#119834;&#119845; &#119810;&#119848;&#119847;&#119853;&#119851;&#119834;&#119836;&#119853;. \n', ' *      It&#39;s currently a place-holder whose only functionality is \n', ' *      forward-compatability with the soon-to-be-deployed actual \n', ' *      contract. \n', ' *\n', ' *      Its job is to accrue funds generated by &#119812;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838; to pay out \n', ' *      as &#119837;&#119842;&#119855;&#119842;&#119837;&#119838;&#119847;&#119837;&#119852; to the &#119819;&#119822;&#119827; token holders. But that&#39;s only the \n', ' *      start. &#119819;&#119822;&#119827; token holders will form a &#119811;&#119808;&#119822; who own and run \n', ' *      &#119812;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;, and will be able to vote of the future of the \n', ' *      platform via this very contract! They&#39;ll also get to say where \n', ' *      &#119812;&#119853;&#119841;&#119825;&#119838;&#119845;&#119842;&#119838;&#119839; - Etheraffle&#39;s charitable arm - funds go to as well. \n', ' *      All whilst earning a &#119837;&#119842;&#119855;&#119842;&#119837;&#119838;&#119847;&#119837; from ticket sales of &#119812;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;! \n', ' *\n', ' *\n', ' *                     &#119812;&#119857;&#119836;&#119842;&#119853;&#119842;&#119847;&#119840; &#119853;&#119842;&#119846;&#119838;&#119852; - &#119852;&#119853;&#119834;&#119858; &#119853;&#119854;&#119847;&#119838;&#119837;!\n', ' *\n', ' *\n', ' *      Learn more and take part at &#119841;&#119853;&#119853;&#119849;&#119852;://&#119838;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;.&#119836;&#119848;&#119846;/&#119842;&#119836;&#119848;\n', ' *      Or if you want to chat to us you have loads of options:\n', ' *      On &#119827;&#119838;&#119845;&#119838;&#119840;&#119851;&#119834;&#119846; @ &#119841;&#119853;&#119853;&#119849;&#119852;://&#119853;.&#119846;&#119838;/&#119838;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;\n', ' *      Or on &#119827;&#119856;&#119842;&#119853;&#119853;&#119838;&#119851; @ &#119841;&#119853;&#119853;&#119849;&#119852;://&#119853;&#119856;&#119842;&#119853;&#119853;&#119838;&#119851;.&#119836;&#119848;&#119846;/&#119838;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;\n', ' *      Or on &#119825;&#119838;&#119837;&#119837;&#119842;&#119853; @ &#119841;&#119853;&#119853;&#119849;&#119852;://&#119838;&#119853;&#119841;&#119838;&#119851;&#119834;&#119839;&#119839;&#119845;&#119838;.&#119851;&#119838;&#119837;&#119837;&#119842;&#119853;.&#119836;&#119848;&#119846;\n', ' *\n', ' */\n', 'pragma solidity^0.4.21;\n', '\n', 'contract ReceiverInterface {\n', '    function receiveEther() external payable {}\n', '}\n', '\n', 'contract EtheraffleDisbursal {\n', '\n', '    bool    upgraded;\n', '    address etheraffle;\n', '    /**\n', '     * @dev  Modifier to prepend to functions rendering them\n', '     *       only callable by the Etheraffle multisig address.\n', '     */\n', '    modifier onlyEtheraffle() {\n', '        require(msg.sender == etheraffle);\n', '        _;\n', '    }\n', '    event LogEtherReceived(address fromWhere, uint howMuch, uint atTime);\n', '    event LogUpgrade(address toWhere, uint amountTransferred, uint atTime);\n', '    /**\n', '     * @dev   Constructor - sets the etheraffle var to the Etheraffle\n', '     *        managerial multisig account.\n', '     *\n', '     * @param _etheraffle   The Etheraffle multisig account\n', '     */\n', '    function EtheraffleDisbursal(address _etheraffle) {\n', '        etheraffle = _etheraffle;\n', '    }\n', '    /**\n', '     * @dev   Upgrade function transferring all this contract&#39;s ether\n', '     *        via the standard receive ether function in the proposed\n', '     *        new disbursal contract.\n', '     *\n', '     * @param _addr    The new disbursal contract address.\n', '     */\n', '    function upgrade(address _addr) onlyEtheraffle external {\n', '        upgraded = true;\n', '        emit LogUpgrade(_addr, this.balance, now);\n', '        ReceiverInterface(_addr).receiveEther.value(this.balance)();\n', '    }\n', '    /**\n', '     * @dev   Standard receive ether function, forward-compatible\n', '     *        with proposed future disbursal contract.\n', '     */\n', '    function receiveEther() payable external {\n', '        emit LogEtherReceived(msg.sender, msg.value, now);\n', '    }\n', '    /**\n', '     * @dev   Set the Etheraffle multisig contract address, in case of future\n', '     *        upgrades. Only callable by the current Etheraffle address.\n', '     *\n', '     * @param _newAddr   New address of Etheraffle multisig contract.\n', '     */\n', '    function setEtheraffle(address _newAddr) onlyEtheraffle external {\n', '        etheraffle = _newAddr;\n', '    }\n', '    /**\n', '     * @dev   selfDestruct - used here to delete this placeholder contract\n', '     *        and forward any funds sent to it on to the final disbursal\n', '     *        contract once it is fully developed. Only callable by the\n', '     *        Etheraffle multisig.\n', '     *\n', '     * @param _addr   The destination address for any ether herein.\n', '     */\n', '    function selfDestruct(address _addr) onlyEtheraffle {\n', '        require(upgraded);\n', '        selfdestruct(_addr);\n', '    }\n', '    /**\n', '     * @dev   Fallback function that accepts ether and announces its\n', '     *        arrival via an event.\n', '     */\n', '    function () payable external {\n', '    }\n', '}']