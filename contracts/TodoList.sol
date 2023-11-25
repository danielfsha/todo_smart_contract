//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract TodoList {
    address public owner;
    string public name;

    uint private _todosCounter;

    struct Todo {
        uint id;
        address owner;
        string content;
        bool isCompleted;
    }

    constructor(string memory _name) {
        name = _name;
        owner = msg.sender;
        _todosCounter = 0;
    }

    mapping(uint => Todo) public allTodos;

    event TodoCreated(
        uint id,
        address owner,
        string content,
        bool isCompleted
    );

    event TodoUpdated(
        uint id,
        string content,
        bool isCompleted
    );

    event TodoToggledIsCompletedState(
        uint id,
        bool isCompleted
    );

    modifier onlyOwner {
        require(msg.sender == owner, "You aren't the owner");
        _;
    }

    function updateName(
        string memory _name
    ) public onlyOwner {
        name = _name;
    }

    function createTodo(
        string memory _content
    ) public onlyOwner {
        uint _id = _todosCounter;

        Todo storage newTodo = allTodos[_id];
        newTodo.id = _id;
        newTodo.owner = msg.sender;
        newTodo.content = _content;
        newTodo.isCompleted = false;

        emit TodoCreated(newTodo.id, newTodo.owner, newTodo.content, newTodo.isCompleted);

        _todosCounter++;
    }

    function updateTodo(
        uint _id, 
        string memory _content, 
        bool _isCompleted
    ) public onlyOwner {
        require(_id <= _todosCounter, "Todo doesn't exist");

        Todo storage todo = allTodos[_id];

        todo.content = _content;
        todo.isCompleted = _isCompleted;

        emit TodoUpdated(todo.id, todo.content, todo.isCompleted);
    }

    function toggleCompletedById(uint _id) public {
        require(msg.sender == allTodos[_id].owner, "You are not the owner of this todo");

        Todo storage todo = allTodos[_id];
        todo.isCompleted = todo.isCompleted ? false : true;

        emit TodoToggledIsCompletedState(todo.id, todo.isCompleted);
    }

    function getAllTodos() public view returns (Todo[] memory) {
        uint totalTodosCount = _todosCounter;

        Todo[] memory todos = new Todo[](totalTodosCount);
        for (uint i = 0; i < totalTodosCount; i++) {
            Todo memory currentTodo = allTodos[i];
            todos[i] = currentTodo;
        }

        return todos;
    }

    function getTodoById(
        uint _id
    ) public view returns (Todo memory) {
        require(_id <= _todosCounter, "Todo doesn't exist");

        Todo memory todo = allTodos[_id];

        return todo;
    }

    function queryCompletedTodosByAddress(
        address _owner
    ) public view returns (Todo[] memory) {
        uint completedTodosCount = 0;
        uint totalTodosCount = _todosCounter;

        for (uint i = 0; i < totalTodosCount; i++) {
            if (allTodos[i].isCompleted == true && allTodos[i].owner == _owner) {
                completedTodosCount++;
            }
        }

        Todo[] memory todos = new Todo[](completedTodosCount);
        uint currentIndex = 0;

        for (uint i = 0; i < totalTodosCount; i++) {
            if (allTodos[i].isCompleted == true && allTodos[i].owner == _owner) {
                todos[currentIndex] = allTodos[i];
                currentIndex++;
            }
        }

        return todos;
    }

    function queryIncompleteTodosByAddress(
        address _owner
    ) public view returns (Todo[] memory) {
        uint incompleteTodosCount = 0;
        uint totalTodosCount = _todosCounter;

        for (uint i = 0; i < totalTodosCount; i++) {
            if (allTodos[i].isCompleted == false && allTodos[i].owner == _owner) {
                incompleteTodosCount++;
            }
        }

        Todo[] memory todos = new Todo[](incompleteTodosCount);
        uint currentIndex = 0;

        for (uint i = 0; i < totalTodosCount; i++) {
            if (allTodos[i].isCompleted == false && allTodos[i].owner == _owner) {
                todos[currentIndex] = allTodos[i];
                currentIndex++;
            }
        }

        return todos;
    }
}
