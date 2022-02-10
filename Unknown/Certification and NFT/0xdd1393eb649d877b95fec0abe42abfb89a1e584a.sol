['pragma solidity ^0.4.11;\n', '\n', '\n', 'contract Consents {\n', '\n', '    enum ActionType { REVOKE, CONSENT, NONE }\n', '\n', '    struct Action {\n', '        ActionType actionType;\n', '        string inputDate;\n', '        string endDate;\n', '    }\n', '\n', '    mapping (address => Action[]) consentHistoryByUser;\n', '\n', '    function giveConsent(string inputDate, string endDate){\n', '        address userId = msg.sender;\n', '        consentHistoryByUser[userId].push(Action(ActionType.CONSENT, inputDate, endDate));\n', '    }\n', '\n', '    function revokeConsent(string inputDate){\n', '        address userId = msg.sender;\n', '        consentHistoryByUser[userId].push(Action(ActionType.REVOKE, inputDate, ""));\n', '    }\n', '\n', '    function getLastAction(address userId) returns (ActionType, string, string) {\n', '        Action[] memory history = consentHistoryByUser[userId];\n', '        if (history.length < 1) {\n', '            return (ActionType.NONE, "", "");\n', '        }\n', '        Action memory lastAction = history[history.length - 1];\n', '        return (lastAction.actionType, lastAction.inputDate, lastAction.endDate);\n', '    }\n', '\n', '    function getActionHistorySize() returns (uint) {\n', '        address userId = msg.sender;\n', '        return consentHistoryByUser[userId].length;\n', '    }\n', '\n', '    function getActionHistoryItem(uint index) returns (ActionType, string, string) {\n', '        address userId = msg.sender;\n', '        Action[] memory history = consentHistoryByUser[userId];\n', '        Action memory action = history[index];\n', '        return (action.actionType, action.inputDate, action.endDate);\n', '    }\n', '\n', '    function strActionType(ActionType actionType) internal constant returns (string) {\n', '        if (actionType == ActionType.REVOKE) {\n', '            return "REVOCATION";\n', '        }\n', '        else if (actionType == ActionType.CONSENT) {\n', '            return "ACTIVATION";\n', '        }\n', '        else {\n', '            return "";\n', '        }\n', '    }\n', '\n', '    function strConcatAction(string accumulator, Action action, bool firstItem) internal constant returns (string) {\n', '\n', '        string memory str_separator = ", ";\n', '        string memory str_link = " ";\n', '\n', '        bytes memory bytes_separator = bytes(str_separator);\n', '        bytes memory bytes_accumulator = bytes(accumulator);\n', '        bytes memory bytes_date = bytes(action.inputDate);\n', '        bytes memory bytes_link = bytes(str_link);\n', '        bytes memory bytes_action = bytes(strActionType(action.actionType));\n', '\n', '        uint str_length = 0;\n', '        str_length += bytes_accumulator.length;\n', '        if (!firstItem) {\n', '            str_length += bytes_separator.length;\n', '        }\n', '        str_length += bytes_date.length;\n', '        str_length += bytes_link.length;\n', '        str_length += bytes_action.length;\n', '\n', '        string memory result = new string(str_length);\n', '        bytes memory bytes_result = bytes(result);\n', '        uint k = 0;\n', '        uint i = 0;\n', '        for (i = 0; i < bytes_accumulator.length; i++) bytes_result[k++] = bytes_accumulator[i];\n', '        if (!firstItem) {\n', '            for (i = 0; i < bytes_separator.length; i++) bytes_result[k++] = bytes_separator[i];\n', '        }\n', '        for (i = 0; i < bytes_date.length; i++) bytes_result[k++] = bytes_date[i];\n', '        for (i = 0; i < bytes_link.length; i++) bytes_result[k++] = bytes_link[i];\n', '        for (i = 0; i < bytes_action.length; i++) bytes_result[k++] = bytes_action[i];\n', '        return string(bytes_result);\n', '\n', '    }\n', '\n', '    function Restitution_Historique_Transactions(address userId) public constant returns (string) {\n', '        Action[] memory history = consentHistoryByUser[userId];\n', '        string memory result = "";\n', '        if (history.length > 0) {\n', '            result = strConcatAction(result, history[0], true);\n', '            for (uint i = 1; i < history.length; i++) {\n', '                result = strConcatAction(result, history[i], false);\n', '            }\n', '        }\n', '        return result;\n', '    }\n', '}']