#include "monty.h"
int main(void)
{
    char line[MAX_LINE_LENGTH];
    unsigned int line_number = 0;
    stack_t *stack = NULL;

    instruction_t instructions[] = {
        {"push", push},
        {"pall", pall},
        {"pint", pint},
        {"pop", pop},
        {"swap", swap},
        {"add", add},
        {"nop", nop},
        /* Add more opcodes here */
        {NULL, NULL}
    };

    while (fgets(line, sizeof(line), stdin) != NULL)
    {
        char *opcode;
        int i;

        line_number++;

        /* Remove trailing newline character */
        line[strcspn(line, "\n")] = '\0';

        /* Extract opcode */
        opcode = strtok(line, " \n");

        /* Check if opcode exists */
        if (opcode == NULL)
            continue;

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

    exit(EXIT_SUCCESS);
}

void push(stack_t **stack, unsigned int line_number)
{
    stack_t *new_node;
    int value;

    char *arg = strtok(NULL, " \n");

    if (arg == NULL)
    {
        fprintf(stderr, "L%d: usage: push integer\n", line_number);
        exit(EXIT_FAILURE);
    }

    value = atoi(arg);

    new_node = malloc(sizeof(stack_t));
    if (new_node == NULL)
    {
        fprintf(stderr, "Error: malloc failed\n");
        exit(EXIT_FAILURE);
    }

    new_node->n = value;
    new_node->prev = NULL;
    new_node->next = *stack;

    if (*stack != NULL)
        (*stack)->prev = new_node;

    *stack = new_node;
}

void pall(stack_t **stack, unsigned int line_number)
{
    stack_t *current = *stack;

    (void)line_number;

    while (current != NULL)
    {
        printf("%d\n", current->n);
        current = current->next;
    }
}

void pint(stack_t **stack, unsigned int line_number)
{
    if (*stack == NULL)
    {
        fprintf(stderr, "L%d: can't pint, stack empty\n", line_number);
        exit(EXIT_FAILURE);
    }

    printf("%d\n", (*stack)->n);
}

void pop(stack_t **stack, unsigned int line_number)
{
    stack_t *temp;

    if (*stack == NULL)
    {
        fprintf(stderr, "L%d: can't pop an empty stack\n", line_number);
        exit(EXIT_FAILURE);
    }

    temp = *stack;
    *stack = (*stack)->next;

    if (*stack != NULL)
        (*stack)->prev = NULL;

    free(temp);
}
