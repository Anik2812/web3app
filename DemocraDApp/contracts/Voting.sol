// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Poll {
        string question;
        string[] options;
        mapping(uint => uint) votes;
        bool active;
    }

    mapping(uint => Poll) public polls;
    uint public pollCount;

    event PollCreated(uint pollId, string question, string[] options);
    event Voted(uint pollId, uint optionId, address voter);

    function createPoll(string memory _question, string[] memory _options) public {
        require(_options.length > 1, "At least two options are required");
        pollCount++;
        Poll storage newPoll = polls[pollCount];
        newPoll.question = _question;
        newPoll.options = _options;
        newPoll.active = true;
        emit PollCreated(pollCount, _question, _options);
    }

    function vote(uint _pollId, uint _optionId) public {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID");
        require(polls[_pollId].active, "Poll is not active");
        require(_optionId < polls[_pollId].options.length, "Invalid option ID");
        
        polls[_pollId].votes[_optionId]++;
        emit Voted(_pollId, _optionId, msg.sender);
    }

    function getPoll(uint _pollId) public view returns (string memory, string[] memory, uint[] memory, bool) {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID");
        Poll storage poll = polls[_pollId];
        uint[] memory voteCounts = new uint[](poll.options.length);
        for (uint i = 0; i < poll.options.length; i++) {
            voteCounts[i] = poll.votes[i];
        }
        return (poll.question, poll.options, voteCounts, poll.active);
    }

    function closePoll(uint _pollId) public {
        require(_pollId > 0 && _pollId <= pollCount, "Invalid poll ID");
        polls[_pollId].active = false;
    }
}