#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * struct stack_s - doubly linked list representation of a stack (or queue)
 * @n: integer
 * @prev: points to the previous element of the stack (or queue)
 * @next: points to the next element of the stack (or queue)
 *
 * Description: doubly linked list node structure
 * for stack, queues, LIFO, FIFO
 */
typedef struct stack_s
{
    int n;
    struct stack_s *prev;
    struct stack_s *next;
} stack_t;

/**
 * struct instruction_s - opcode and its function
 * @opcode: the opcode
 * @f: function to handle the opcode
 *
 * Description: opcode and its function
 * for stack, queues, LIFO, FIFO
 */
typedef struct instruction_s
{
    char *opcode;
    void (*f)(stack_t **stack, unsigned int line_number);
} instruction_t;

/* Function prototypes */
void push(stack_t **stack, unsigned int line_number);
void pall(stack_t **stack, unsigned int line_number);

/* Global variable: stack */
stack_t *stack = NULL;

/* Main program */
int main(void)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t read;
    unsigned int line_number = 0;

    instruction_t instructions[] = {
        {"push", push},
        {"pall", pall},
        /* Add more opcodes here */
        {NULL, NULL}
    };

    while ((read = getline(&line, &len, stdin)) != -1)
    {
        char *opcode, *arg;
        int i;

        line_number++;

        /* Extract opcode */
        opcode = strtok(line, " \n");

        /* Check if opcode exists */
        if (opcode == NULL)
            continue;

        /* Extract argument */
        arg = strtok(NULL, " \n");

        /* Find opcode in instruction set */
        for (i = 0; instructions[i].opcode != NULL; i++)
        {
            if (strcmp(opcode, instructions[i].opcode) == 0)
            {
                /* Call opcode function */
                instructions[i].f(&stack, line_number);

                /* Stop searching for opcode */
                break;
            }
        }

        /* If opcode not found, print error message */
        if (instructions[i].opcode == NULL)
        {
            fprintf(stderr, "L%d: unknown instruction %s\n", line_number, opcode);
            exit(EXIT_FAILURE);
        }
    }

    free(line);
    exit(EXIT_SUCCESS);
}

/**
 * push - Pushes an element to the stack.
 * @stack: Double pointer to the head of the stack.
 * @line_number: Line number of the push opcode.
 */
void push(stack_t **stack, unsigned int line_number)
{
    stack_t *new_node;
    int value;

    /* Extract argument (integer) */
    char *arg = strtok(NULL, " \n");

    /* Check if argument exists */
    if (arg == NULL)
    {
        fprintf(stderr, "L%d: usage: push integer\n", line_number);
        exit(EXIT_FAILURE);
    }

    /* Convert argument to integer */
    value = atoi(arg);

    /* Create new node */
    new_node = malloc(sizeof(stack_t));
    if (new_node == NULL)
    {
        fprintf(stderr, "Error: malloc failed\n");
        exit(EXIT_FAILURE);
    }

    /* Assign values to the new node */
    new_node->n = value;
    new_node->prev = NULL;
    new_node->next = *stack;

    /* Update previous node's prev pointer */
    if (*stack != NULL)
        (*stack)->prev = new_node;

    /* Update stack pointer */
    *stack = new_node;
}

/**
 * pall - Prints all values on the stack.
 * @stack: Double pointer to the head of the stack.
 * @line_number: Line number of the pall opcode.
 */
void pall(stack_t **stack, unsigned int line_number)
{
    stack_t *current = *stack;

    (void)line_number;

    /* Traverse the stack and print values */
    while (current != NULL)
    {
        printf("%d\n", current->n);
        current = current->next;
    }
}
